import 'dart:io';
import 'dart:convert';

String readJson(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  final content = File('$dir/test/$name').readAsStringSync();
  // Parse and re-encode to ensure clean JSON without problematic characters
  final jsonData = json.decode(content);
  return json.encode(jsonData);
}
