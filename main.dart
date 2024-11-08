import 'character.dart';
import 'monster.dart';
import 'function.dart';

void main() {
  Character character = loadCharacterStats();
  List<Monster> monsters = loadMonsters();
  battle(character, monsters);
}
