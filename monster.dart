import 'dart:math';
import 'character.dart';

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
