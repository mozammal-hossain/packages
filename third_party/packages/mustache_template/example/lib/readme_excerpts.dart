// This file hosts README code excerpts (see README.md) and is imported by the
// example runner and excerpt tests.

// ignore_for_file: public_member_api_docs

import 'package:mustache_template/mustache_template.dart';

String basicRenderExample() {
  // #docregion BasicRender
  const source = '''
{{# names }}
<div>{{ lastname }}, {{ firstname }}</div>
{{/ names }}
{{^ names }}
<div>No names.</div>
{{/ names }}
{{! I am a comment. }}
''';

  final template = Template(source, name: 'names-template');
  final String output = template.renderString(<String, Object>{
    'names': <Map<String, String>>[
      <String, String>{'firstname': 'Greg', 'lastname': 'Lowe'},
      <String, String>{'firstname': 'Bob', 'lastname': 'Johnson'},
    ],
  });
  // #enddocregion BasicRender
  return output;
}

String nestedPathsExample() {
  // #docregion NestedPaths
  final template = Template('{{ author.name }}');
  final String output = template.renderString(<String, Object>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
  // #enddocregion NestedPaths
  return output;
}

String partialsExample() {
  // #docregion Partials
  final partial = Template('{{ foo }}', name: 'partial');
  Template resolver(String name) {
    if (name == 'partial-name') {
      return partial;
    }
    throw StateError('Unknown partial: $name');
  }

  final template = Template('{{> partial-name }}', partialResolver: resolver);
  final String output = template.renderString(<String, String>{'foo': 'bar'});
  // #enddocregion Partials
  return output;
}

String lambdaSimpleExample() {
  // #docregion LambdaSimpleValue
  final template = Template('{{ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (_) => 'bar',
  });
  // #enddocregion LambdaSimpleValue
  return output;
}

String lambdaShownExample() {
  // #docregion LambdaSectionReplacement
  final template = Template('{{# foo }}hidden{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (_) => 'shown',
  });
  // #enddocregion LambdaSectionReplacement
  return output;
}

String lambdaRenderExample() {
  // #docregion LambdaRenderString
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (LambdaContext context) =>
        '<b>${context.renderString().toUpperCase()}</b>',
    'bar': 'pub',
  });
  // #enddocregion LambdaRenderString
  return output;
}

String lambdaRenderSourceExample() {
  // #docregion LambdaRenderSource
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (LambdaContext context) =>
        context.renderSource('${context.source} {{cmd}}'),
    'bar': 'pub',
    'cmd': 'build',
  });
  // #enddocregion LambdaRenderSource
  return output;
}

String strictVsLenientLenientOutput() {
  // #docregion StrictVsLenient
  try {
    Template('{{missing}}').renderString(<String, Object>{});
  } on TemplateException catch (_) {
    // Strict mode (default): missing keys throw when rendering.
  }

  final String lenientOutput = Template(
    '{{missing}}',
    lenient: true,
  ).renderString(<String, Object>{});
  // #enddocregion StrictVsLenient
  return lenientOutput;
}
