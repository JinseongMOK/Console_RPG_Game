import 'dart:io';
import 'dart:math';

class Character {
  String name;
  int health;
  int attack;
  int defense;

  Character(this.name, this.health, this.attack, this.defense);

  void display() {
    print('이름: ${name}, 체력: ${health}, 공격력: ${attack}, 방어력: ${defense}');
  }

  int takeDamage(int damage) {
    int damageTaken = max(damage - defense, 0);
    health = max(health - damageTaken, 0);
    return damageTaken;
  }

  int attackTarget(Monster monster) {
    int damageDealt = monster.takeDamage(attack);
    print('${name}이 ${monster.name}에게 ${damageDealt}의 데미지를 입혔습니다.');
    print('');
    return damageDealt;
  }
}

class Monster {
  String name;
  int health;
  int attack;
  int defense;

  Monster(this.name, this.health, this.attack, this.defense);

  void display() {
    print('이름: ${name}, 체력: ${health}, 공격력: ${attack}, 방어력: ${defense}');
  }

  int takeDamage(int damage) {
    int damageTaken = max(damage - defense, 0);
    health = max(health - damageTaken, 0);
    return damageTaken;
  }

  int attackTarget(Character character) {
    int damageDealt = character.takeDamage(attack);
    print('${name}이 ${character.name}에게 ${damageDealt}의 데미지를 입혔습니다.');
    print('');
    return damageDealt;
  }
}

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
    int defense = 5; // 기본 방어력

    monsters.add(Monster(name, health, attack, defense));
  }
  return monsters;
}

void saveResult(int monstersDefeated) {
  final outputFile = File('result.txt');
  outputFile.writeAsStringSync('사냥한 몬스터 수: ${monstersDefeated}\n');
}

void battle(Character character, List<Monster> monsters) {
  Random random = Random();
  int monstersDefeated = 0;

  while (true) {
    // 랜덤으로 몬스터 선택
    Monster monster = monsters[random.nextInt(monsters.length)];
    print('\n새로운 몬스터가 나타났습니다!');
    monster.display();

    while (character.health > 0 && monster.health > 0) {
      // 30% 확률로 캐릭터 체력 회복
      if (random.nextDouble() < 0.3) {
        character.health += 10;
        print('${character.name}의 체력이 10 증가했습니다! 현재 체력: ${character.health}');
      }

      // 캐릭터의 행동 선택
      print('${character.name}의 턴입니다 (1: 공격, 2: 방어): ');
      String? choice = stdin.readLineSync();

      if (choice == '1') {
        character.attackTarget(monster);
      } else if (choice == '2') {
        print('${character.name}이 방어 했습니다.');
        print('');
      }

      // 몬스터가 쓰러졌는지 확인
      if (monster.health <= 0) {
        print('${monster.name}을 물리쳤습니다!');
        monstersDefeated++;
        break;
      }

      // 몬스터의 턴
      monster.attackTarget(character);

      // 캐릭터가 쓰러졌는지 확인
      if (character.health <= 0) {
        print('${character.name}이 쓰러졌습니다.');
        saveResult(monstersDefeated);
        return;
      }
    }

    // 다음 몬스터와 싸울지 여부 확인
    print('다음 몬스터와 싸우시겠습니까? (y/n): ');
    String? continueChoice = stdin.readLineSync();
    if (continueChoice != 'y') {
      saveResult(monstersDefeated);
      print('게임 종료! ${monstersDefeated}마리의 몬스터를 사냥했습니다.');
      return;
    }
  }
}

void main() {
  Character character = loadCharacterStats();
  List<Monster> monsters = loadMonsters();
  battle(character, monsters);
}
