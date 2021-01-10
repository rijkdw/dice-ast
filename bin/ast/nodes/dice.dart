import '../../utils.dart';
import '../objects/setopvalue.dart';
import 'die.dart';
import '../objects/token.dart';
import 'node.dart';
import 'setlike.dart';

class Dice extends SetLike {

  // attributes

  Token token;
  int number, size;
  // children (from SetLike) will all be Die nodes.

  // constructor

  Dice(this.token, this.number, this.size) {
    children = <Die>[];
  }

  // factory

  factory Dice.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return Dice(token, int.parse(matches.first), int.parse(matches.last));
  }

  // methods

  /// Roll [number]d[size].
  void roll() {
    children = <Die>[];
    for (var i = 0; i < number; i++) {
      children.add(_rollAnother());
    }
  }

  /// Roll one [Die] according to this [Dice]'s [size].
  Die _rollAnother() {
    return Die.roll(size);
  }

  void applyOpWithValues(String op, SetOpValueList setOpValueList) {
    // explode
    if (op == 'e') {
      for (var i = 0; i < children.length; i++) {
        var dieI = die[i];
        if (dieI.isKept && setOpValueList.contains(dieI.value)) {
          // do the explode sequence
          setOpValueList.use(dieI.value); // use the value
          var newDie = _rollAnother();    // get a new Die
          children.insert(i+1, newDie);   // insert it just behind the current Die
          dieI.explode();                 // mark the current die as exploded
        }
      }
    }
    // reroll infinitely
    if (op == 'r') {
      for (var i = 0; i < children.length; i++) {
        var dieI = die[i];
        if (dieI.isKept && setOpValueList.contains(dieI.value)) {
          // do the reroll sequence
          setOpValueList.use(dieI.value); // use
          var newDie = _rollAnother();    // get new
          children.insert(i+1, newDie);   // add to list
          dieI.discard();                 // discard original
        }
      }
    }
    // reroll once
    if (op == 'o') {
      for (var i = 0; i < children.length; i++) {
        var dieI = die[i];
        if (dieI.isKept && setOpValueList.contains(dieI.value)) {
          // do the reroll-once sequence
          setOpValueList.use(dieI.value); // use
          var newDie = _rollAnother();    // get new
          children.insert(i+1, newDie);   // add to list
          dieI.discard();                 // discard original
          i++;                            // don't consider new dice
        }
      }
    }
    // reroll once and add
    if (op == 'a') {
      for (var i = 0; i < children.length; i++) {
        var dieI = die[i];
        if (dieI.isKept && setOpValueList.contains(dieI.value)) {
          // do the reroll-once-and-add sequence
          setOpValueList.use(dieI.value); // use
          var newDie = _rollAnother();    // get new
          children.insert(i+1, newDie);   // add to list
          i++;                            // don't consider new dice
        }
      }
    }
    // minimum
    if (op == 'n') {
      for (var i = 0; i < children.length; i++) {
        var dieI = die[i];
        if (dieI.isKept && dieI.value < setOpValueList.values.first) {
          dieI.value = setOpValueList.values.first;   // rewrite
        }
      }
    }
    // maximum
    if (op == 'x') {
      for (var i = 0; i < children.length; i++) {
        var dieI = die[i];
        if (dieI.isKept && dieI.value > setOpValueList.values.first) {
          dieI.value = setOpValueList.values.first;   // rewrite
        }
      }
    }
  }

  // override Node methods

  @override
  List<Die> get die => List<Die>.from(children);

  @override
  String visualise() {
    var setOpsVisualised = join(setOps.map((s) => '${s.op}${s.sel}${s.val}').toList(), '');
    return '${number}d${size}${setOpsVisualised}';
  }

  @override
  Node get copy {
    var copyOfThis = Dice(token.copy, number, size);
    // copyOfThis.children.addAll(children.map((c) => c.copy).toList());
    return copyOfThis;
  }

  // override Object methods

  @override
  String toString() {
    var output = 'Dice(total=$value, number=$number, size=$size, children=$children, setOps=$setOps)';
    return output;
  }

  
}