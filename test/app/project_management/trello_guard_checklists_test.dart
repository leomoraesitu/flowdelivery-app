import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Trello guard checklist parity', () {
    final canonicalLocalization = _readMarkdownChecklist(
      File('docs/project-management/DEFINITION_OF_DONE.md'),
      'Localization Guard Checklist',
    );
    final canonicalTheme = _readMarkdownChecklist(
      File('docs/project-management/DEFINITION_OF_DONE.md'),
      'Theme Guard Checklist',
    );

    test('TRELLO_WORKFLOW uses the same guard checklist items', () {
      expect(
        _readMarkdownChecklist(
          File('docs/project-management/TRELLO_WORKFLOW.md'),
          'Localization Guard Checklist',
        ),
        canonicalLocalization,
      );
      expect(
        _readMarkdownChecklist(
          File('docs/project-management/TRELLO_WORKFLOW.md'),
          'Theme Guard Checklist',
        ),
        canonicalTheme,
      );
    });

    test('Trello JSON templates keep existing guard checklists canonical', () {
      final templateDirectory = Directory(
        'docs/project-management/trello/templates',
      );
      final templateFiles =
          templateDirectory
              .listSync()
              .whereType<File>()
              .where((file) => file.path.endsWith('.json'))
              .toList()
            ..sort((left, right) => left.path.compareTo(right.path));

      expect(templateFiles, isNotEmpty);

      for (final file in templateFiles) {
        final template = jsonDecode(file.readAsStringSync());
        final cards = _collectCards(template);

        for (final card in cards) {
          final cardName = card['name'] as String? ?? '<unnamed card>';
          final checklists = card['checklists'];
          if (checklists is! List<Object?>) {
            continue;
          }

          for (final checklist
              in checklists.whereType<Map<String, Object?>>()) {
            final checklistName = checklist['name'];
            final expectedItems = switch (checklistName) {
              'Localization Guard Checklist' => canonicalLocalization,
              'Theme Guard Checklist' => canonicalTheme,
              _ => null,
            };

            if (expectedItems == null) {
              continue;
            }

            final actualItems = _readJsonChecklistItems(checklist);
            expect(
              actualItems,
              expectedItems,
              reason:
                  '${file.path} card "$cardName" checklist "$checklistName" '
                  'must match DEFINITION_OF_DONE.md.',
            );
          }
        }
      }
    });
  });
}

List<String> _readMarkdownChecklist(File file, String heading) {
  final lines = file.readAsLinesSync();
  final items = <String>[];
  var insideTargetHeading = false;
  var insideFence = false;

  for (final line in lines) {
    if (line.trimLeft().startsWith('```')) {
      insideFence = !insideFence;
      continue;
    }

    if (insideFence) {
      continue;
    }

    final trimmed = line.trim();
    if (trimmed.startsWith('#')) {
      if (insideTargetHeading) {
        break;
      }

      insideTargetHeading = _headingText(trimmed) == heading;
      continue;
    }

    if (insideTargetHeading && trimmed.startsWith('- [ ] ')) {
      items.add(trimmed.substring('- [ ] '.length));
    }
  }

  if (items.isEmpty) {
    throw StateError('Checklist "$heading" not found in ${file.path}.');
  }

  return items;
}

String _headingText(String markdownHeading) {
  return markdownHeading.replaceFirst(RegExp(r'^#+\s*'), '');
}

List<Map<String, Object?>> _collectCards(Object? value) {
  final cards = <Map<String, Object?>>[];

  void visit(Object? node) {
    if (node is Map<String, Object?>) {
      if (node.containsKey('name') && node.containsKey('desc')) {
        cards.add(node);
      }
      for (final child in node.values) {
        visit(child);
      }
    } else if (node is List<Object?>) {
      for (final child in node) {
        visit(child);
      }
    }
  }

  visit(value);
  return cards;
}

List<String> _readJsonChecklistItems(Map<String, Object?> checklist) {
  final checkItems = checklist['checkItems'];
  if (checkItems is! List<Object?>) {
    return const [];
  }

  final indexedItems = <({String name, int pos})>[];
  for (final item in checkItems.whereType<Map<String, Object?>>()) {
    final name = item['name'];
    final pos = item['pos'];
    if (name is String && pos is int) {
      indexedItems.add((name: name, pos: pos));
    }
  }

  indexedItems.sort((left, right) => left.pos.compareTo(right.pos));
  return [for (final item in indexedItems) item.name];
}
