import '../../utils.dart';
import '../../state.dart' as state;
import 'node.dart';

class Die extends Node {

  // attributes

  int size;
  List<int> values;
  bool exploded = false;
  bool rerolled = false;

  // constructor

  Die(this.size, int value) {
    values = <int>[value];
  }

  // factory methods

  factory Die.roll(int size) {
    state.addRollAndCheck();
    var value = randInRange(1, size);
    return Die(size, value);
  }

  // setters

  set value(newValue) => values.add(newValue);
  void explode() => exploded = true;

  // getters

  bool get isOverwritten => values.length > 1;

  bool get isCrit => value == size;
  bool get isFail => value == 1;

  // override Node methods
  
  @override
  int get value => values.last;

  @override
  List<Die> get die => [this];

  @override
  String visualise() => '$value';

  // override Object methods

  @override
  String toString() {
    var output = 'Die(size=$size, values=$values';
    output += exploded ? ', --exploded' : '';
    output += isOverwritten ? ', --overwritten' : '';
    output += isDiscarded ? ', --discarded' : '';
    return output + ')';
  }
}

void main() {
  for (var size in [4, 6, 8, 10, 12, 20]) {
    print(Die.roll(size));
  }
}
