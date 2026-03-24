// ignore_for_file: avoid_print

import 'package:mustache_template/mustache_template.dart';

void showBasicRendering() {
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
  print(output);
}

void showNestedPaths() {
  // #docregion NestedPaths
  final template = Template('{{ author.name }}');
  final String output = template.renderString(<String, Object>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
  // #enddocregion NestedPaths
  print(output);
}

void showPartials() {
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
  print(output);
}

void showLambdaSimpleValue() {
  // #docregion LambdaSimpleValue
  final template = Template('{{# foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (_) => 'bar',
  });
  // #enddocregion LambdaSimpleValue
  print(output);
}

void showLambdaSectionReplacement() {
  // #docregion LambdaSectionReplacement
  final template = Template('{{# foo }}hidden{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (_) => 'shown',
  });
  // #enddocregion LambdaSectionReplacement
  print(output);
}

void showLambdaRenderString() {
  // #docregion LambdaRenderString
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (LambdaContext context) =>
        '<b>${context.renderString().toUpperCase()}</b>',
    'bar': 'pub',
  });
  // #enddocregion LambdaRenderString
  print(output);
}

void showLambdaRenderSource() {
  // #docregion LambdaRenderSource
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (LambdaContext context) =>
        context.renderSource('${context.source} {{cmd}}'),
    'bar': 'pub',
    'cmd': 'build',
  });
  // #enddocregion LambdaRenderSource
  print(output);
}

void showStrictVsLenientBehavior() {
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
  print(lenientOutput);
}

void main() {
  showBasicRendering();
  showNestedPaths();
  showPartials();
  showLambdaSimpleValue();
  showLambdaSectionReplacement();
  showLambdaRenderString();
  showLambdaRenderSource();
  showStrictVsLenientBehavior();
}
