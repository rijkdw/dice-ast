import '../utils.dart';
import '../state.dart' as state;

class Die {
  int size;
  List<int> values;

  Die(this.size);

  factory Die.roll(int size) {
    state.addRollAndCheck();
    var value = randInRange(1, size);
    var die = Die(size);
    die.values = [value];
    return die;
  }

  int get value => values.last;

  @override
  String toString() => 'Die(size=$size, values=$values)';
}

void main() {
  for (var size in [4, 6, 8, 10, 12, 20]) {
    print(Die.roll(size));
  }
}
