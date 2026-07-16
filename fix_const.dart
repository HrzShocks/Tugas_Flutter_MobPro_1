import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    
    // Remove const keyword if it appears before a widget that uses AppColors
    // This is hard to do with regex, but we can do a naive approach:
    // If a block of code (between const and the next semicolon or comma) contains AppColors, we remove const.
    // Instead of complex regex, let's just do it manually for the files with errors.
  }
}
