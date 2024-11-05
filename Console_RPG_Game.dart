import 'dart:io';

void readCharacters() {
  File file = File('Characters.txt');

  // File의 모든 내용을 가져옴
  String contents = file.readAsStringSync();
  print(contents);
}
