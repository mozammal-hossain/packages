// ignore_for_file: avoid_relative_lib_imports

import 'dart:async';

import 'package:mustache_template/mustache_template.dart';
import 'package:mustache_template_example/readme_excerpts.dart'
    as readme_excerpts;
import 'package:test/test.dart';

import '../main.dart' as example_app;

void main() {
  group('Example app', () {
    test('example app runs without error', () {
      expect(
        () => runZoned<void>(
          () => example_app.main(),
          zoneSpecification: ZoneSpecification(
            print: (Zone self, ZoneDelegate parent, Zone zone, String line) {},
          ),
        ),
        returnsNormally,
      );
    });
  });

  group('README excerpts', () {
    test('basic render example includes rendered names', () {
      final String out = readme_excerpts.basicRenderExample();
      expect(out, contains('Lowe, Greg'));
      expect(out, contains('Johnson, Bob'));
    });

    test('nested paths example renders the nested value', () {
      expect(readme_excerpts.nestedPathsExample(), equals('Greg Lowe'));
    });

    test('partials example renders the partial output', () {
      expect(readme_excerpts.partialsExample(), equals('bar'));
    });

    test('simple lambda example renders the replacement text', () {
      expect(readme_excerpts.lambdaSimpleExample(), equals('bar'));
    });

    test('lambda block example renders the alternate text', () {
      expect(readme_excerpts.lambdaShownExample(), equals('shown'));
    });

    test('lambda render example uppercases the section body', () {
      expect(readme_excerpts.lambdaRenderExample(), equals('<b>PUB</b>'));
    });

    test('lambda renderSource example reparses in the current context', () {
      expect(readme_excerpts.lambdaRenderSourceExample(), equals('pub build'));
    });

    test('strict mode throws for missing keys; lenient renders empty', () {
      expect(
        () => Template('{{missing}}').renderString(<String, Object>{}),
        throwsA(isA<TemplateException>()),
      );
      expect(readme_excerpts.strictVsLenientLenientOutput(), isEmpty);
    });
  });
}
