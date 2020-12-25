import '../utils.dart';
import '../state.dart' as state;

class Die {
  int size;
  int _myValue;
  bool exploded = false;
  bool kept = true;
  bool rerolled = false;
  int _originalValue;

  Die(this.size, this._myValue) {
    _originalValue = _myValue;
  }

  factory Die.roll(int size) {
    state.addRollAndCheck();
    var value = randInRange(1, size);
    return Die(size, value);
  }

  int get value => _myValue;
  set value(newValue) => _myValue = newValue;

  void explode() => exploded = true;
  void discard() => kept = false;

  bool get isOverwritten => _myValue != _originalValue;

  @override
  String toString() {
    var output = 'Die(size=$size, value=$_myValue';
    output += kept ? '' : ', --discarded';
    output += exploded ? ', --exploded' : '';
    output += isOverwritten ? ', --overwritten, originalValue=$_originalValue' : '';
    output += rerolled ? ', --rerolled, originalValue=$_originalValue' : '';
    output += ')';
    return output;
  }
}

void main() {
  for (var size in [4, 6, 8, 10, 12, 20]) {
    print(Die.roll(size));
  }
}
