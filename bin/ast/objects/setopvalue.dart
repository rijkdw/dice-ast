import '../../error.dart';
import '../../utils.dart';

class SetOpValue {

  // attributes

  int value;
  bool reusable;
  bool _used = false;

  SetOpValue(this.value, this.reusable);

  // "use" methods

  void use() => _used = true;

  bool get isUsed {
    if (reusable) return false;
    return _used;
  }

  bool get isAvailable => !isUsed;

  // override Object methods

  @override
  String toString() => 'SetOpValue(value=$value, reusable=$reusable, isUsed=$isUsed)';

}

class SetOpValueList {

  List<SetOpValue> _setOpValues;

  SetOpValueList(List<SetOpValue> setOpValues) {
    _setOpValues = List<SetOpValue>.from(setOpValues);
  }

  List<int> get values => _setOpValues.map((sov) => sov.value).toList();
  int get minValue => minInList(values);
  int get maxValue => maxInList(values);

  bool contains(int value) {
    for (var setOpValue in _setOpValues) {
      if (setOpValue.value == value && setOpValue.isAvailable) {
        return true;
      }
    }
    return false;
  }

  SetOpValue use(int value) {
    if (!contains(value)) {
      raiseError(ErrorType.generic, 'Cannot use $value with $this');
    };
    for (var setOpValue in _setOpValues) {
      // cannot use a used value
      if (setOpValue.value == value && setOpValue.isAvailable) {
        setOpValue.use();
        return setOpValue;
      }
    }
  }

  SetOpValueList operator +(SetOpValueList other) {
    var newList = _setOpValues;
    newList.addAll(other._setOpValues);
    newList = newList.toSet().toList();
    return SetOpValueList(newList);
  }

  // override Object methods

  @override
  String toString() => 'SetOpValueList(setOpValues=$_setOpValues)';
}

void main() {
  var a = SetOpValueList([
    SetOpValue(1, true),
    SetOpValue(2, true),
    SetOpValue(3, true),
  ]);
  var b = SetOpValueList([
    SetOpValue(1, true),
    SetOpValue(2, true),
    SetOpValue(4, true),
  ]);
  print(a+b);
}