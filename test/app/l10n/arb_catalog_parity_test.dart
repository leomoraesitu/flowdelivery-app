import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ARB catalog parity', () {
    final catalogs = <_ArbCatalog>[
      _ArbCatalog.load('lib/l10n/app_pt_BR.arb', expectedLocale: 'pt_BR'),
      _ArbCatalog.load('lib/l10n/app_pt.arb', expectedLocale: 'pt'),
      _ArbCatalog.load('lib/l10n/app_en.arb', expectedLocale: 'en'),
    ];

    final template = catalogs.firstWhere(
      (catalog) => catalog.expectedLocale == 'pt_BR',
    );

    test('all ARB files declare the locale matching their filename', () {
      final failures = <String>[];

      for (final catalog in catalogs) {
        if (catalog.locale != catalog.expectedLocale) {
          failures.add(
            '${catalog.path}: expected @@locale '
            '"${catalog.expectedLocale}", found "${catalog.locale}".',
          );
        }
      }

      expect(failures, isEmpty, reason: failures.join('\n'));
    });

    test(
      'translated catalogs contain the same string keys as the template',
      () {
        final failures = <String>[];
        final expectedKeys = template.stringKeys;

        for (final catalog in catalogs.where(
          (catalog) => catalog != template,
        )) {
          final missingKeys = expectedKeys.difference(catalog.stringKeys);
          final extraKeys = catalog.stringKeys.difference(expectedKeys);

          if (missingKeys.isNotEmpty) {
            failures.add(
              '${catalog.path}: missing keys ${_formatKeys(missingKeys)}.',
            );
          }

          if (extraKeys.isNotEmpty) {
            failures.add(
              '${catalog.path}: unexpected keys ${_formatKeys(extraKeys)}.',
            );
          }
        }

        expect(failures, isEmpty, reason: failures.join('\n'));
      },
    );

    test('template string keys have descriptions', () {
      final missingDescriptions = template.stringKeys
          .where((key) => !template.hasDescriptionFor(key))
          .toList();

      expect(
        missingDescriptions,
        isEmpty,
        reason:
            '${template.path}: every template string key needs '
            '@key.description metadata. Missing descriptions for '
            '${_formatKeys(missingDescriptions)}.',
      );
    });

    test('metadata entries are not orphaned', () {
      final failures = <String>[];

      for (final catalog in catalogs) {
        final orphanMetadataKeys = catalog.metadataBaseKeys.difference(
          catalog.stringKeys,
        );

        if (orphanMetadataKeys.isNotEmpty) {
          failures.add(
            '${catalog.path}: orphan metadata for '
            '${_formatKeys(orphanMetadataKeys)}.',
          );
        }
      }

      expect(failures, isEmpty, reason: failures.join('\n'));
    });
  });
}

class _ArbCatalog {
  const _ArbCatalog({
    required this.path,
    required this.expectedLocale,
    required this.values,
  });

  factory _ArbCatalog.load(String path, {required String expectedLocale}) {
    final file = File(path);
    final decoded = jsonDecode(file.readAsStringSync());

    if (decoded is! Map<String, Object?>) {
      throw StateError('$path must contain a JSON object.');
    }

    return _ArbCatalog(
      path: path,
      expectedLocale: expectedLocale,
      values: decoded,
    );
  }

  final String path;
  final String expectedLocale;
  final Map<String, Object?> values;

  String? get locale => values['@@locale'] as String?;

  Set<String> get stringKeys {
    return values.entries
        .where((entry) => _isStringResource(entry.key, entry.value))
        .map((entry) => entry.key)
        .toSet();
  }

  Set<String> get metadataBaseKeys {
    return values.keys
        .where((key) => key.startsWith('@') && !key.startsWith('@@'))
        .map((key) => key.substring(1))
        .toSet();
  }

  bool hasDescriptionFor(String key) {
    final metadata = values['@$key'];
    return metadata is Map<String, Object?> &&
        metadata['description'] is String &&
        (metadata['description'] as String).trim().isNotEmpty;
  }
}

bool _isStringResource(String key, Object? value) {
  return value is String && !key.startsWith('@');
}

String _formatKeys(Iterable<String> keys) {
  final sortedKeys = keys.toList()..sort();
  return sortedKeys.map((key) => '`$key`').join(', ');
}
