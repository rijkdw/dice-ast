import '../../utils.dart';
import '../objects/die.dart';
import '../objects/setop.dart';
import '../objects/token.dart';
import 'setlike.dart';

class Dice extends SetLike {
  Token token;
  int number, size;
  List<Die> _die;
  List<SetOp> setOps;

  Dice(this.token, this.number, this.size) {
    setOps = [];
    _die = [];
  }

  factory Dice.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return Dice(token, int.parse(matches.first), int.parse(matches.last));
  }

  void evaluate() {
    // operators:
    // k, p:      mark Die as unkept, as appropriate by selector
    // e:         mark Die as exploded and roll another die
    // r, o, a:   reroll Die...
      // r        reroll Die infinitely, discard original
      // o        reroll Die once, discard original
      // a        reroll Die once, keep original
    // n, x:      overwrite Die value with V if smaller / larger than V

    // selectors:
    // h, l:      require access to full values
    // s, >, <    do not require access to full values

    // invalid selectors for operators:
    // n, x:      >, <, h, l
  }

  Die _rollAnother() {
    return Die.roll(size);
  }

  List<int> _getSetOpValues(SetOp setOp) {
    // if the selector is >X, then make a list [X+1 -> MAX]
    if (setOp.sel == '>') {
      return makeList(setOp.val+1, _maxDieValue);
    }
    // if the selector is <X, then make a list [MIN -> X-1]
    if (setOp.sel == '<') {
      return makeList(_minDieValue, setOp.val-1);
    }
    // if the selector is =X, then make a list [X]
    if (setOp.sel == '=') {
      return <int>[setOp.val];
    }
    // if the selector is hX, then make a list of highest X values
    if (setOp.sel == 'h') {
      var dieValuesSorted = _keptDieValues;
      dieValuesSorted.sort();
      return List<int>.from(sublist(dieValuesSorted.reversed.toList(), 0, setOp.val-1));
    }
    // if the selector is lX, then make a list of lowest X values
    if (setOp.sel == 'l') {
      var dieValuesSorted = _keptDieValues;
      dieValuesSorted.sort();
      return List<int>.from(sublist(dieValuesSorted, 0, setOp.val-1));
    }
    return [];
  }

  List<int> _invertSetOpValues(List<int> setOpValues) {
    var outList = <int>[];
    for (var i = 1; i < _maxDieValue+1; i++) {
      if (!setOpValues.contains(i)) {
        outList.add(i);
      }
    }
    return outList;
  }

  int get _maxDieValue => size;
  int get _minDieValue => 1;

  // set operators

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }

  @override
  String toString() => 'DiceNode(number=$number, size=$size, die=$_die, setOps=$setOps)';

  @override
  String visualise() => '${number}d${size}';

  @override
  int get value => sumList(_keptDieValues);

  List<int> get _keptDieValues {
    var outList = <int>[];
    for (var d in _die) {
      if (d.kept) {
        outList.add(d.value);
      }
    }
    return outList;
  }

  @override
  List<Die> get die => _die;
}