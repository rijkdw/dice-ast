import 'die.dart';

class Dice {
  int number, size;
  List<Die> die;

  Dice(this.number, this.size, this.die);

  factory Dice.roll(number, size) {
    var die = [];
    for (var i = 0; i < number; i++) {
      die.add(Die.roll(size));
    }
    return Dice(number, size, List<Die>.from(die));
  }

  @override
  String toString() =>
      'Dice(number=$number, size=$size, die=${die.map((d) => d.toString()).toList()}';
}

void main() {
  print(Dice.roll(4, 6));
  print(Dice.roll(2, 20).die);
}
