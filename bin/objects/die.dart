import '../utils.dart';

class Die {
  int size, value;

  Die(this.size, this.value);

  factory Die.roll(int size) {
    var value = randInRange(1, size);
    return Die(size, value);
  }

  @override
  String toString() => 'Die(size=$size, value=$value)';
}

void main() {
  for (var size in [4, 6, 8, 10, 12, 20]) {
    print(Die.roll(size));
  }
}
