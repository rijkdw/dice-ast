import '../../error.dart';
import '../../utils.dart';
import '../objects/setop.dart';
import '../objects/setopvalue.dart';
import 'dice.dart';
import 'die.dart';
import 'node.dart';
import 'set.dart';

abstract class SetLike extends Node {

  // attributes

  List<Node> children = <Node>[];
  List<SetOp> setOps = <SetOp>[];

  // getters

  /// The node's children that have not been discarded.
  List<Node> get keptChildren {
    var list = <Node>[];
    children.forEach((child) {
      if (child.isKept) {
        list.add(child);
      }
    });
    return list;
  }
  
  /// The values of the node's children that have not been discarded.
  List<int> get keptChildrenValues => keptChildren.map((child) => child.value).toList();
  int get _maxChildValue => maxInList(keptChildrenValues);
  int get _minChildValue => minInList(keptChildrenValues);

  // override Node methods

  @override
  int get value => sumList(keptChildrenValues);

  @override
  List<Die> get die => List<Die>.from(joinLists(children.map((child) => child.die).toList()));

  // SetOps

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }

  SetOpValueList generateSetOpValues(SetOp setOp) {
    // example inputs and outputs (* means reusable):
    // [1, 2, 3] & h1   => [3]
    // [1, 2, 3] & >1   => [2*, 3*]
    // [1, 2, 3] & =1   => [1*]
    // [1, 2, 3] & <3   => [1*, 2*]
    if (setOp.sel == '=') {
      return SetOpValueList([SetOpValue(setOp.val, true)]);
    }
    if (setOp.sel == '>') {
      return SetOpValueList(makeList(setOp.val+1, _maxChildValue).map((v) => SetOpValue(v, true)).toList());
    }
    if (setOp.sel == '<') {
      return SetOpValueList(makeList(_minChildValue, setOp.val-1).map((v) => SetOpValue(v, true)).toList());
    }
    if (setOp.sel == 'h') {
      return SetOpValueList(getSafeMaxN(keptChildrenValues, setOp.val).map((v) => SetOpValue(v, false)).toList());
    }
    if (setOp.sel == 'l') {
      return SetOpValueList(getSafeMinN(keptChildrenValues, setOp.val).map((v) => SetOpValue(v, false)).toList());
    }
    raiseError(ErrorType.generic, 'Selector ${setOp.sel} is unknown to me');
    return null;
  }

  void _applyOpWithValues(String op, SetOpValueList setOpValueList) {
    // if this is something only applicable to a Dice, throw it over to Dice
    if (this is Dice && ['e', 'r', 'o', 'a', 'n', 'x'].contains(op)) {
      (this as Dice).applyOpWithValues(op, setOpValueList);
    }
  }

  void applySetOps() {
    print('SetOps on this SetLike: $setOps');
    // operators:
    // k, p:      mark Die as unkept, as appropriate by selector
    // e:         mark Die as exploded and roll another die
    // r, o, a:   reroll Die...
      // r        reroll Die infinitely, discard original
      // o        reroll Die once, discard original
      // a        reroll Die once, keep original
    // n, x:      overwrite Die value with V if smaller / larger than V

    // selectors:
    // h, l:      require access to full values -- relative
    // s, >, <    do not require access to full values -- absolute

    for (var i = 0; i < setOps.length; i++) {
      var setOp = setOps[i];

      // check if setOp can be applied to this SetLike
      if (['e', 'r', 'o', 'a', 'n', 'x'].contains(setOp.op) && this is Set) {
        print('Skipping because an invalid operator is used on a Set');
        continue;
      }

      // if op=='e' or op=='r', merge together with following matching SetOps
      if (['e', 'r'].contains(setOp.op)) {
        var setOpValueList = generateSetOpValues(setOp);
        var lookahead = i+1;
        while (lookahead < setOps.length && setOps[lookahead].op == setOp.op) {
          i++; // so that it isn't used again later
          setOpValueList += generateSetOpValues(setOps[lookahead]);
          lookahead++;
        }
        print(setOpValueList);
        _applyOpWithValues(setOp.op, setOpValueList);
      }
      
    }
  }
}