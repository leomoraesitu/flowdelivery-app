import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation and route files do not add hardcoded user-facing strings', () {
    final projectRoot = Directory.current.path;
    final targets = <String>[
      '$projectRoot/lib/features',
      '$projectRoot/lib/app/routes',
    ];

    final violations = <String>[];

    for (final target in targets) {
      final directory = Directory(target);
      if (!directory.existsSync()) {
        continue;
      }

      for (final entity in directory.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) {
          continue;
        }

        final normalizedPath = entity.path.replaceAll('\\', '/');
        if (!normalizedPath.contains('/presentation/') &&
            !normalizedPath.contains('/app/routes/')) {
          continue;
        }

        final content = entity.readAsStringSync();
        if (_isAllowedFile(content)) {
          continue;
        }

        for (final pattern in _hardcodedUiCopyPatterns) {
          final match = pattern.firstMatch(content);
          if (match != null) {
            final lineNumber = _lineNumberForOffset(content, match.start);
            violations.add(
              '$normalizedPath:$lineNumber: ${match.group(0)!.trim()}',
            );
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Found hardcoded user-facing copy in UI files. Add the string to ARB files and read it with AppLocalizations.\n${violations.join('\n')}',
    );
  });
}

final _hardcodedUiCopyPatterns = <RegExp>[
  RegExp(r'''Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''hintText:\s*['"][^'"]+['"]'''),
  RegExp(r'''labelText:\s*['"][^'"]+['"]'''),
  RegExp(r'''helperText:\s*['"][^'"]+['"]'''),
  RegExp(r'''title:\s*['"][^'"]+['"]'''),
  RegExp(r'''subtitle:\s*['"][^'"]+['"]'''),
  RegExp(r'''leadingText:\s*['"][^'"]+['"]'''),
  RegExp(r'''errorText:\s*['"][^'"]+['"]'''),
  RegExp(r'''TextSpan\([^\)]*text:\s*['"][^'"]+['"]'''),
  RegExp(r'''SnackBar\([\s\S]*content:\s*Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''SnackBarAction\([^\)]*label:\s*['"][^'"]+['"]'''),
  RegExp(r'''Tooltip\([\s\S]*message:\s*['"][^'"]+['"]'''),
  RegExp(r'''semanticLabel:\s*['"][^'"]+['"]'''),
  RegExp(r'''AlertDialog\([\s\S]*title:\s*Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''AlertDialog\([\s\S]*content:\s*Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''showDialog\([\s\S]*AlertDialog\([\s\S]*title:\s*Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''showDialog\([\s\S]*AlertDialog\([\s\S]*content:\s*Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''SimpleDialog\([\s\S]*title:\s*Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''BottomSheet\([\s\S]*(child|title|content):\s*Text\(\s*['"][^'"]+['"]'''),
  RegExp(r'''showModalBottomSheet\([\s\S]*builder:\s*\([\s\S]*Text\(\s*['"][^'"]+['"]'''),
];

bool _isAllowedFile(String content) {
  return content.contains('// l10n-guard: ignore');
}

int _lineNumberForOffset(String content, int offset) {
  var lineNumber = 1;
  for (var index = 0; index < offset && index < content.length; index++) {
    if (content.codeUnitAt(index) == 10) {
      lineNumber++;
    }
  }

  return lineNumber;
}