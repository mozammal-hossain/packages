// ignore_for_file: avoid_print

import 'package:mustache_template/mustache_template.dart';

// #docregion BasicRender
void showBasicRendering() {
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
  print(output);
}
// #enddocregion BasicRender

// #docregion NestedPaths
void showNestedPaths() {
  final template = Template('{{ author.name }}');
  final String output = template.renderString(<String, Object>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
  print(output);
}
// #enddocregion NestedPaths

// #docregion Partials
void showPartials() {
  final partial = Template('{{ foo }}', name: 'partial');
  Template resolver(String name) {
    if (name == 'partial-name') {
      return partial;
    }
    throw StateError('Unknown partial: $name');
  }

  final template = Template('{{> partial-name }}', partialResolver: resolver);
  final String output = template.renderString(<String, String>{'foo': 'bar'});
  print(output);
}
// #enddocregion Partials

// #docregion Lambdas
void showLambdas() {
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (LambdaContext context) =>
        '<b>${context.renderString().toUpperCase()}</b>',
    'bar': 'pub',
  });
  print(output);
}
// #enddocregion Lambdas

// #docregion StrictVsLenient
void showStrictVsLenientBehavior() {
  final strictTemplate = Template('{{missing}}');
  try {
    strictTemplate.renderString(<String, Object>{});
  } on TemplateException catch (exception) {
    print(exception.message);
  }

  final lenientTemplate = Template('{{missing}}', lenient: true);
  final String output = lenientTemplate.renderString(<String, Object>{});
  print(output);
}
// #enddocregion StrictVsLenient

void main() {
  showBasicRendering();
  showNestedPaths();
  showPartials();
  showLambdas();
  showStrictVsLenientBehavior();
}
