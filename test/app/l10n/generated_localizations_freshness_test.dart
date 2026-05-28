import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('generated localization freshness', () {
    test('template ARB string keys are exposed by AppLocalizations', () {
      final template = _ArbCatalog.load('lib/l10n/app_pt_BR.arb');
      final generatedApi = File(
        'lib/l10n/generated/app_localizations.dart',
      ).readAsStringSync();

      final missingGeneratedAccessors =
          template.stringKeys
              .where((key) => !_hasGeneratedAccessor(generatedApi, key))
              .toList()
            ..sort();

      expect(
        missingGeneratedAccessors,
        isEmpty,
        reason:
            'Run flutter gen-l10n after changing ARB files. Missing generated '
            'AppLocalizations accessors for ${_formatKeys(missingGeneratedAccessors)}.',
      );
    });
  });
}

class _ArbCatalog {
  const _ArbCatalog({required this.values});

  factory _ArbCatalog.load(String path) {
    final decoded = jsonDecode(File(path).readAsStringSync());

    if (decoded is! Map<String, Object?>) {
      throw StateError('$path must contain a JSON object.');
    }

    return _ArbCatalog(values: decoded);
  }

  final Map<String, Object?> values;

  Set<String> get stringKeys {
    return values.entries
        .where((entry) => entry.value is String && !entry.key.startsWith('@'))
        .map((entry) => entry.key)
        .toSet();
  }
}

bool _hasGeneratedAccessor(String generatedApi, String key) {
  final getterPattern = RegExp('String\\s+get\\s+${RegExp.escape(key)}\\s*;');
  final methodPattern = RegExp('String\\s+${RegExp.escape(key)}\\s*\\(');

  return getterPattern.hasMatch(generatedApi) ||
      methodPattern.hasMatch(generatedApi);
}

String _formatKeys(Iterable<String> keys) {
  return keys.map((key) => '`$key`').join(', ');
}
