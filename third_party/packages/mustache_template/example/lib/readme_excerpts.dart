// This file hosts README code excerpts (see README.md) and is imported by the
// example runner and excerpt tests.

// ignore_for_file: public_member_api_docs, prefer_final_locals, specify_nonobvious_local_variable_types, prefer_function_declarations_over_variables, prefer_interpolation_to_compose_strings

import 'package:mustache_template/mustache_template.dart';

String basicRenderExample() {
  // #docregion BasicRender
  var source = '''
{{# names }}
<div>{{ lastname }}, {{ firstname }}</div>
{{/ names }}
{{^ names }}
<div>No names.</div>
{{/ names }}
{{! I am a comment. }}
''';

  var template = Template(source, name: 'names-template');
  var output = template.renderString(<String, Object>{
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
  var t = Template('{{ author.name }}');
  var output = t.renderString(<String, Object>{
    'author': {'name': 'Greg Lowe'},
  });
  // #enddocregion NestedPaths
  return output;
}

String partialsExample() {
  // #docregion Partials
  var partial = Template('{{ foo }}', name: 'partial');
  Template resolver(String name) {
    if (name == 'partial-name') {
      return partial;
    }
    throw StateError('Unknown partial: $name');
  }

  var t = Template('{{> partial-name }}', partialResolver: resolver);
  var output = t.renderString({'foo': 'bar'}); // bar
  // #enddocregion Partials
  return output;
}

String lambdaSimpleExample() {
  // #docregion LambdaSimpleValue
  var t = Template('{{ foo }}');

  var lambda = (_) => 'bar';

  var output = t.renderString({'foo': lambda}); // bar
  // #enddocregion LambdaSimpleValue
  return output;
}

String lambdaShownExample() {
  // #docregion LambdaSectionReplacement
  var t = Template('{{# foo }}hidden{{/ foo }}');
  var lambda = (_) => 'shown';

  var output = t.renderString({'foo': lambda}); // shown
  // #enddocregion LambdaSectionReplacement
  return output;
}

String lambdaUppercaseOibExample() {
  // #docregion LambdaUppercaseOib
  var t = Template('{{# foo }}oi{{/ foo }}');
  var lambda = (LambdaContext ctx) =>
      '<b>${ctx.renderString().toUpperCase()}</b>';

  var output = t.renderString({'foo': lambda}); // <b>OI</b>
  // #enddocregion LambdaUppercaseOib
  return output;
}

String lambdaRenderExample() {
  // #docregion LambdaRenderString
  var t = Template('{{# foo }}{{bar}}{{/ foo }}');
  var lambda = (LambdaContext context) =>
      '<b>${context.renderString().toUpperCase()}</b>';

  var output = t.renderString({'foo': lambda, 'bar': 'pub'}); // <b>PUB</b>
  // #enddocregion LambdaRenderString
  return output;
}

String lambdaRenderSourceExample() {
  // #docregion LambdaRenderSource
  var t = Template('{{# foo }}{{bar}}{{/ foo }}');
  var lambda = (LambdaContext ctx) => ctx.renderSource(ctx.source + ' {{cmd}}');

  var output = t.renderString({
    'foo': lambda,
    'bar': 'pub',
    'cmd': 'build',
  }); // pub build
  // #enddocregion LambdaRenderSource
  return output;
}

String strictModeBehaviorExample() {
  // #docregion StrictMode
  late String result;
  try {
    Template('{{missing}}').renderString({});
    result = 'No exception thrown (unexpected)';
  } on TemplateException catch (e) {
    // Strict mode (default): missing keys throw when rendering.
    result = 'Strict mode exception: ${e.runtimeType}';
  }
  // #enddocregion StrictMode
  return result;
}

String lenientModeBehaviorExample() {
  // #docregion LenientMode
  final t = Template('{{missing}}', lenient: true);
  final String output = t.renderString({}); // ''
  // #enddocregion LenientMode
  return output;
}
