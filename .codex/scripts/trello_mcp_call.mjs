#!/usr/bin/env node

import { spawn } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

const projectPath = process.cwd();
const configPath = path.join(os.homedir(), '.claude.json');

function usage() {
  console.error(
    [
      'Usage:',
      '  node .codex/scripts/trello_mcp_call.mjs list-tools',
      "  node .codex/scripts/trello_mcp_call.mjs call <tool_name> '<json_args>'",
      '',
      'Examples:',
      "  node .codex/scripts/trello_mcp_call.mjs call get_checklist_by_name '{\"cardId\":\"v7eDZSQc\",\"name\":\"Scope\"}'",
      "  node .codex/scripts/trello_mcp_call.mjs call update_checklist_item '{\"cardId\":\"v7eDZSQc\",\"checkItemId\":\"...\",\"state\":\"complete\"}'",
    ].join('\n'),
  );
}

function loadTrelloServerConfig() {
  const rawConfig = fs.readFileSync(configPath, 'utf8');
  const config = JSON.parse(rawConfig);
  const server = config.projects?.[projectPath]?.mcpServers?.trello;

  if (!server) {
    throw new Error(`No Claude Trello MCP config found for ${projectPath}.`);
  }

  if (server.type !== 'stdio') {
    throw new Error(`Unsupported Trello MCP transport: ${server.type}.`);
  }

  return server;
}

function parseArgs() {
  const [, , command, toolName, rawArgs] = process.argv;

  if (command === 'list-tools') {
    return { command };
  }

  if (command === 'call' && toolName) {
    let args = {};

    if (rawArgs) {
      args = JSON.parse(rawArgs);
    }

    return { command, toolName, args };
  }

  usage();
  process.exit(2);
}

function createMcpClient(server) {
  const child = spawn(server.command, server.args ?? [], {
    env: { ...process.env, ...(server.env ?? {}) },
    stdio: ['pipe', 'pipe', 'pipe'],
  });

  let nextId = 1;
  let buffer = '';
  const pending = new Map();

  child.stdout.on('data', (chunk) => {
    buffer += chunk.toString('utf8');
    const lines = buffer.split('\n');
    buffer = lines.pop() ?? '';

    for (const line of lines) {
      if (!line.trim()) {
        continue;
      }

      const message = JSON.parse(line);
      const resolve = pending.get(message.id);

      if (resolve) {
        pending.delete(message.id);
        resolve(message);
      }
    }
  });

  child.stderr.on('data', (chunk) => {
    process.stderr.write(chunk);
  });

  function send(method, params) {
    const id = nextId;
    nextId += 1;

    const message = { jsonrpc: '2.0', id, method, params };
    child.stdin.write(`${JSON.stringify(message)}\n`);

    return new Promise((resolve) => {
      pending.set(id, resolve);
    });
  }

  function notify(method, params = {}) {
    child.stdin.write(`${JSON.stringify({ jsonrpc: '2.0', method, params })}\n`);
  }

  function close() {
    child.kill();
  }

  return { child, send, notify, close };
}

async function withTimeout(promise, timeoutMs) {
  let timeout;

  const timeoutPromise = new Promise((_, reject) => {
    timeout = setTimeout(() => {
      reject(
        new Error(
          `Timed out after ${timeoutMs}ms. If this runs inside a sandbox, ` +
            'rerun with approval because the Claude Trello MCP starts through npx.',
        ),
      );
    }, timeoutMs);
  });

  try {
    return await Promise.race([promise, timeoutPromise]);
  } finally {
    clearTimeout(timeout);
  }
}

async function main() {
  const args = parseArgs();
  const server = loadTrelloServerConfig();
  const client = createMcpClient(server);

  try {
    await withTimeout(
      client.send('initialize', {
        protocolVersion: '2024-11-05',
        capabilities: {},
        clientInfo: { name: 'codex-trello-helper', version: '1.0.0' },
      }),
      20000,
    );

    client.notify('notifications/initialized');

    const response =
      args.command === 'list-tools'
        ? await withTimeout(client.send('tools/list', {}), 30000)
        : await withTimeout(
            client.send('tools/call', {
              name: args.toolName,
              arguments: args.args,
            }),
            30000,
          );

    console.log(JSON.stringify(response, null, 2));
  } finally {
    client.close();
  }
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
