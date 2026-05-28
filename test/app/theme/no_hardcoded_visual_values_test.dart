import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('presentation files do not add forbidden visual hardcoded values', () {
    final projectRoot = Directory.current.path;
    final target = Directory('$projectRoot/lib/features');
    final violations = <String>[];

    if (!target.existsSync()) {
      fail('Target directory not found: ${target.path}');
    }

    for (final entity in target.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }

      final normalizedPath = entity.path.replaceAll('\\', '/');
      if (!normalizedPath.contains('/presentation/')) {
        continue;
      }

      final content = entity.readAsStringSync();

      for (final pattern in _forbiddenVisualPatterns) {
        for (final match in pattern.allMatches(content)) {
          final matchedText = match.group(0) ?? '';
          final lineNumber = _lineNumberForOffset(content, match.start);
          violations.add('$normalizedPath:$lineNumber: ${matchedText.trim()}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Found forbidden visual hardcoded values in presentation files. Use semantic theme APIs/tokens and keep low-level palette usage inside lib/app/theme.\n${violations.join('\n')}',
    );
  });
}

final _forbiddenVisualPatterns = <RegExp>[
  RegExp(r'Color\(\s*0x[0-9A-Fa-f]{8}\s*\)'),
  RegExp(r'\bAppLightColors\.[A-Za-z0-9_]+'),
  RegExp(r'\bAppDarkColors\.[A-Za-z0-9_]+'),
];

int _lineNumberForOffset(String content, int offset) {
  var lineNumber = 1;
  for (var index = 0; index < offset && index < content.length; index++) {
    if (content.codeUnitAt(index) == 10) {
      lineNumber++;
    }
  }

  return lineNumber;
}
