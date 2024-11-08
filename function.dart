import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';

// 캐릭터 정보
Character loadCharacterStats() {
  final file = File('characters.txt');
  final contents = file.readAsStringSync();
  final stats = contents.split(',');

  if (stats.length != 3) throw FormatException('Invalid character data');

  String name = getCharacterName();
  int health = int.parse(stats[0]);
  int attack = int.parse(stats[1]);
  int defense = int.parse(stats[2]);

  Character character = Character(name, health, attack, defense);
  character.display();
  return character;
}

String getCharacterName() {
  print("캐릭터 이름을 입력하세요:");
  return stdin.readLineSync() ?? "Player";
}

// 몬스터 정보
List<Monster> loadMonsters() {
  final file = File('monsters.txt');
  final lines = file.readAsLinesSync();
  List<Monster> monsters = [];

  for (var line in lines) {
    final stats = line.split(',');

    if (stats.length != 3) {
      print('Invalid monster data in line: ${line}');
      continue;
    }

    String name = stats[0];
    int health = int.parse(stats[1]);
    int attack = int.parse(stats[2]);
    int defense = 5;

    monsters.add(Monster(name, health, attack, defense));
  }
  return monsters;
}

// 파일 저장
void saveResult(int monstersDefeated) {
  final outputFile = File('result.txt');
  outputFile.writeAsStringSync('사냥한 몬스터 수: ${monstersDefeated}\n');
}

// 몬스터 사냥
void battle(Character character, List<Monster> monsters) {
  Random random = Random();
  int monstersDefeated = 0;

  while (true) {
    Monster monster = monsters[random.nextInt(monsters.length)];
    print('\n새로운 몬스터가 나타났습니다!');
    monster.display();

    // 30% 확률로 캐릭터 체력 10 증가
    while (character.health > 0 && monster.health > 0) {
      if (random.nextInt(100) < 30) {
        character.health += 10;
        print('${character.name}의 체력이 10 증가했습니다! 현재 체력: ${character.health}');
      }

      print('${character.name}의 턴입니다 (1: 공격, 2: 방어): ');
      String? choice = stdin.readLineSync();

      if (choice == '1') {
        character.attackTarget(monster);
      } else if (choice == '2') {
        print('${character.name}이 방어 했습니다.');
        print('');
      }

      if (monster.health <= 0) {
        print('${monster.name}을 물리쳤습니다!');
        monstersDefeated++;
        break;
      }

      monster.attackTarget(character);

      if (character.health <= 0) {
        print('${character.name}이 쓰러졌습니다.');
        saveResult(monstersDefeated);
        return;
      }
    }

    // 다음 게임 진행여부 판단
    print('다음 몬스터와 싸우시겠습니까? (y/n): ');
    String? continueChoice = stdin.readLineSync();
    if (continueChoice != 'y') {
      saveResult(monstersDefeated);
      print('게임 종료! ${monstersDefeated}마리의 몬스터를 사냥했습니다.');
      return;
    }
  }
}
