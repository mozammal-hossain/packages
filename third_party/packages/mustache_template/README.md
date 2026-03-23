<?code-excerpt path-base="example"?>

# Mustache templates

A Dart library to parse and render [mustache templates](https://mustache.github.io/).

See the [mustache manual](http://mustache.github.com/mustache.5.html) for detailed
usage information.

This library passes all
[mustache specification](https://github.com/mustache/spec/tree/master/specs)
tests.

Templates are parsed when created and can be rendered repeatedly with different
values. A `TemplateException` is thrown if there is a problem parsing or
rendering. Passing `name` to `Template` improves error messages by identifying
which template failed.

By default, output from `{{variable}}` tags is HTML-escaped. You can disable this
with `htmlEscapeValues: false`, or use `{{{triple mustache}}}` / `{{&unescaped}}`
for unescaped output.

## Basic usage

<?code-excerpt "main.dart (BasicRender)"?>
```dart
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
```

## Strict mode vs lenient mode

### Strict mode (default)

- Tag names may only contain `a-z`, `A-Z`, `0-9`, underscore, period, and minus.
  Invalid characters throw `TemplateException` during parsing.
- Rendering throws `TemplateException` when a referenced key/member is missing.

### Lenient mode

- Tag names may contain any characters.
- Missing keys/members render as empty output.

<?code-excerpt "main.dart (StrictVsLenient)"?>
```dart
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
```

## Nested paths

<?code-excerpt "main.dart (NestedPaths)"?>
```dart
void showNestedPaths() {
  final template = Template('{{ author.name }}');
  final String output = template.renderString(<String, Object>{
    'author': <String, String>{'name': 'Greg Lowe'},
  });
  print(output);
}
```

## Partials

<?code-excerpt "main.dart (Partials)"?>
```dart
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
```

## Lambdas

<?code-excerpt "main.dart (Lambdas)"?>
```dart
void showLambdas() {
  final template = Template('{{# foo }}{{bar}}{{/ foo }}');
  final String output = template.renderString(<String, Object>{
    'foo': (LambdaContext context) =>
        '<b>${context.renderString().toUpperCase()}</b>',
    'bar': 'pub',
  });
  print(output);
}
```
