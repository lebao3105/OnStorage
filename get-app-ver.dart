// https://stackoverflow.com/a/72039291

import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

String pathToYaml = join(dirname(Platform.script.toFilePath()), './pubspec.yaml');

Future<YamlMap> loadPubspec() async => loadYaml(await File(pathToYaml).readAsString());

void main() async {
  var pubspec = await loadPubspec();
  print(pubspec['version'].toString().split('+')[0]);
}