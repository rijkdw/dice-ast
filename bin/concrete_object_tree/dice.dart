import '../abstract_syntax_tree/die.dart';

class Dice {
  int number, size;
  List<Die> die;

  Dice(this.number, this.size, this.die);

  factory Dice.roll(number, size) {
    var dieList = <Die>[];
    for (var i = 0; i < number; i++) {
      dieList.add(Die.roll(size));
    }
    return Dice(number, size, dieList);
  }

  @override
  String toString() => 'Dice(number=$number, size=$size, die=${die.map((d) => d.toString()).toList()}';
}

void main() {
  print(Dice.roll(4, 6));
  print(Dice.roll(2, 20).die);
}
