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

    test('template placeholder metadata and translations stay aligned', () {
      final failures = <String>[
        ..._templatePlaceholderMetadataFailures(template),
      ];

      for (final catalog in catalogs.where((catalog) => catalog != template)) {
        failures.addAll(
          _placeholderParityFailures(template: template, catalog: catalog),
        );
      }

      expect(failures, isEmpty, reason: failures.join('\n'));
    });

    test('template placeholders are declared in metadata', () {
      final failures = _templatePlaceholderMetadataFailures(
        _ArbCatalog(
          path: 'memory/template.arb',
          expectedLocale: 'pt_BR',
          values: const {
            '@@locale': 'pt_BR',
            'cartItemQuantity': '{quantity} itens',
            '@cartItemQuantity': {'description': 'Cart item count label.'},
          },
        ),
      );

      expect(
        failures,
        contains(
          'memory/template.arb: `cartItemQuantity` uses placeholder '
          '`quantity` without metadata.',
        ),
      );
    });

    test('translated catalogs preserve template placeholders', () {
      final failures = _placeholderParityFailures(
        template: _ArbCatalog(
          path: 'memory/app_pt_BR.arb',
          expectedLocale: 'pt_BR',
          values: const {
            '@@locale': 'pt_BR',
            'cartItemQuantity': '{quantity} itens',
            '@cartItemQuantity': {
              'description': 'Cart item count label.',
              'placeholders': {
                'quantity': {'type': 'int', 'example': '3'},
              },
            },
          },
        ),
        catalog: _ArbCatalog(
          path: 'memory/app_en.arb',
          expectedLocale: 'en',
          values: const {'@@locale': 'en', 'cartItemQuantity': '{count} items'},
        ),
      );

      expect(
        failures,
        contains(
          'memory/app_en.arb: `cartItemQuantity` placeholders differ from '
          'template. Missing `quantity`; unexpected `count`.',
        ),
      );
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

  String valueFor(String key) {
    final value = values[key];

    if (value is! String) {
      throw StateError('$path: `$key` must be a string resource.');
    }

    return value;
  }

  Set<String> placeholdersInValue(String key) {
    return _placeholderNamesIn(valueFor(key));
  }

  Set<String> metadataPlaceholdersFor(String key) {
    final metadata = values['@$key'];
    if (metadata is! Map<String, Object?>) {
      return <String>{};
    }

    final placeholders = metadata['placeholders'];
    if (placeholders is! Map<String, Object?>) {
      return <String>{};
    }

    return placeholders.keys.toSet();
  }
}

bool _isStringResource(String key, Object? value) {
  return value is String && !key.startsWith('@');
}

String _formatKeys(Iterable<String> keys) {
  final sortedKeys = keys.toList()..sort();
  return sortedKeys.map((key) => '`$key`').join(', ');
}

List<String> _templatePlaceholderMetadataFailures(_ArbCatalog template) {
  final failures = <String>[];

  for (final key in template.stringKeys) {
    final valuePlaceholders = template.placeholdersInValue(key);
    final metadataPlaceholders = template.metadataPlaceholdersFor(key);
    final missingMetadata = valuePlaceholders.difference(metadataPlaceholders);
    final orphanMetadata = metadataPlaceholders.difference(valuePlaceholders);

    for (final placeholder in _sorted(missingMetadata)) {
      failures.add(
        '${template.path}: `$key` uses placeholder '
        '`$placeholder` without metadata.',
      );
    }

    for (final placeholder in _sorted(orphanMetadata)) {
      failures.add(
        '${template.path}: `$key` declares metadata placeholder '
        '`$placeholder` that is not used.',
      );
    }
  }

  return failures;
}

List<String> _placeholderParityFailures({
  required _ArbCatalog template,
  required _ArbCatalog catalog,
}) {
  final failures = <String>[];

  for (final key in template.stringKeys.intersection(catalog.stringKeys)) {
    final templatePlaceholders = template.placeholdersInValue(key);
    final catalogPlaceholders = catalog.placeholdersInValue(key);

    final missingPlaceholders = templatePlaceholders.difference(
      catalogPlaceholders,
    );
    final unexpectedPlaceholders = catalogPlaceholders.difference(
      templatePlaceholders,
    );

    if (missingPlaceholders.isEmpty && unexpectedPlaceholders.isEmpty) {
      continue;
    }

    final details = <String>[];
    if (missingPlaceholders.isNotEmpty) {
      details.add('Missing ${_formatKeys(missingPlaceholders)}');
    }
    if (unexpectedPlaceholders.isNotEmpty) {
      details.add('unexpected ${_formatKeys(unexpectedPlaceholders)}');
    }

    failures.add(
      '${catalog.path}: `$key` placeholders differ from template. '
      '${details.join('; ')}.',
    );
  }

  return failures;
}

Set<String> _placeholderNamesIn(String value) {
  final placeholders = <String>{};
  final pattern = RegExp(r'\{([A-Za-z][A-Za-z0-9_]*)(?:[,}])');

  for (final match in pattern.allMatches(value)) {
    final placeholder = match.group(1);
    if (placeholder != null) {
      placeholders.add(placeholder);
    }
  }

  return placeholders;
}

List<String> _sorted(Iterable<String> values) {
  return values.toList()..sort();
}
