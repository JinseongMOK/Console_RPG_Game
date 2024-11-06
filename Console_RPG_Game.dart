import 'dart:io';

class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);

  void display() {
    print('Name: $name, Health: $health, Attack: $attack, Defense: $defense');
  }
}

String getCharacterName() {
  RegExp nameRegExp = RegExp(r'^[a-zA-Z가-힣]+$');
  String? characterName;

  while (true) {
    print("캐릭터 이름을 입력하세요. (영어 대소문자와 한글만 가능):");
    characterName = stdin.readLineSync();

    if (characterName != null && nameRegExp.hasMatch(characterName)) {
      return characterName;
    } else {
      print("영어 대소문자와 한글만 사용하세요.");
    }
  }
}

void loadCharacterStats() {
  try {
    final file = File('characters.txt');
    final contents = file.readAsStringSync();
    final stats = contents.split(',');

    if (stats.length != 3) throw FormatException('Invalid character data');

    int health = int.parse(stats[0]);
    int attack = int.parse(stats[1]);
    int defense = int.parse(stats[2]);

    String name = getCharacterName();
    Character character = Character(name, health, attack, defense);
    character.display();
  } catch (e) {
    print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
    exit(1);
  }
}

void main() {
  loadCharacterStats();
}
