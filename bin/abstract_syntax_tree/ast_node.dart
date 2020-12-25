import '../utils.dart';
import 'die.dart';
import '../error.dart';
import 'setop.dart';
import 'token.dart';

class AstNode {

  // ignore: missing_return
  String visualise() {
    raiseError(ErrorType.notImplemented);
  }

  num get value => 0;
  // for a binary node, this would = A OP B
  // for a unary node, this would = OP A
  // for a dice node, this would be the sum of the results of its rolls
  // for a literal node, this would be its value

  List<Die> get die => [];
}

// =============================================================================
// PARENT NODES
// =============================================================================

class BinOpNode extends AstNode {
  Token token, op;
  AstNode left, right;

  BinOpNode(this.left, this.op, this.right) {
    token = op;
  }

  @override
  String toString() => 'BinOpNode(left=$left, op=$op, right=$right)';

  @override
  String visualise() => '(${left.visualise()}${op.value}${right.visualise()})';

  @override
  num get value {
    if (op.type == TokenType.PLUS) {
      return left.value + right.value;
    }
    if (op.type == TokenType.MINUS) {
      return left.value - right.value;
    }
    if (op.type == TokenType.MUL) {
      return left.value * right.value;
    }
    if (op.type == TokenType.DIV) {
      return left.value / right.value;
    }
    return 0;
  }

  @override
  List<Die> get die => left.die + right.die;
}

class UnaryOpNode extends AstNode {
  Token token, op;
  AstNode child;

  UnaryOpNode(this.token, this.child) {
    op = token;
  }

  @override
  String toString() => 'UnaryOpNode(op=$op, child=$child)';

  @override
  String visualise() => '${op.value}${child.visualise()}';

  @override
  num get value {
    if (op.type == TokenType.PLUS) {
      return child.value;
    }
    if (op.type == TokenType.MINUS) {
      return -child.value;
    }
    return 0;
  }

  @override
  List<Die> get die => child.die;
}

class SetNode extends AstNode {
  Token token;
  List<AstNode> children;
  List<SetOp> setOps;

  SetNode(this.token, this.children) {
    setOps = [];
  }

  @override
  String toString() {
    return 'SetNode(children=$children, setOps=$setOps)';
  }

  @override
  String visualise() => '[' + join(children.map((c) => c.visualise()).toList(), ', ') + ']';

  @override
  num get value => sumList(children.map((child) => child.value).toList());

  @override
  List<Die> get die {
    var childrenDie = <Die>[];
    for (var child in children) {
      childrenDie.addAll(child.die);
    }
    return childrenDie;
  }

  // set operators

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }

}

class SetOpNode extends AstNode {
  String op, sel;
  int val;
  AstNode child;

  SetOpNode(this.child, this.op, this.sel, this.val);

  @override
  String toString() => 'SetOpNode(op=$op, sel=$sel, val=$val, child=$child)';

  @override
  String visualise() => '${child.visualise()}$op$sel$val';

  @override
  List<Die> get die => child.die;

  AstNode getEventualChild() {
    if (child is SetOpNode) {
      return (child as SetOpNode).getEventualChild();
    }
    return child;
  }

  SetOp get setOp => SetOp(op, sel, val);

  
}

// =============================================================================
// LEAF NODES
// =============================================================================

class LiteralNode extends AstNode {
  Token token;
  num literalValue;

  LiteralNode(this.token) {
    literalValue = token.value;
  }

  @override
  String toString() => 'LiteralNode(value=$literalValue)';

  @override
  String visualise() => '${literalValue}';

  @override
  num get value => literalValue;

  @override
  List<Die> get die => <Die>[];
}


class DiceNode extends AstNode {
  Token token;
  int number, size;
  List<Die> _die;
  List<SetOp> setOps;

  DiceNode(this.token, this.number, this.size) {
    setOps = [];
    _die = [];
  }

  factory DiceNode.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return DiceNode(token, int.parse(matches.first), int.parse(matches.last));
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
    _die = <Die>[];
    for (var i = 0; i < number; i++) {
      _die.add(_rollAnother());
    }

    // apply setops
    for (var i = 0; i < setOps.length; i++) {
      var setOp = setOps[i];

      // check if setOp is valid - if not, skip it
      if (!setOp.isValid) {
        continue;
      }
      print('Looking at $setOp');

      // if an (e | r) operator, merge with following matching operators
      if (['e', 'r'].contains(setOp.op)) {
        var setOpValues = _getSetOpValues(setOp);
        var lookahead = i+1;
        while (lookahead < setOps.length && setOp.op == setOps[lookahead].op) {
          setOpValues.addAll(_getSetOpValues(setOps[lookahead]));
          lookahead++;
          i++;  // so that this setOp is unused in the next round of the outer for-loop
        }
        setOpValues = setOpValues.toSet().toList();
        // print('Merged values = $setOpValues');

        // explode / reroll with these merged values
        for (var j = 0; j < _die.length; j++) {
          // if it's an explode operator
          if (setOp.op == 'e') {
            while (setOpValues.contains(_die[j].value) && _die[j].kept) {
              _die[j].exploded = true;
              var newDie = _rollAnother();
              _die.insert(j+1, newDie);
              j++;
            } 
          }
          // if it's a reroll operator
          if (setOp.op == 'r') {
            while (setOpValues.contains(_die[j].value) && _die[j].kept) {
              _die[j].rerolled = true;
              _die[j].discard();
              var newDie = _rollAnother();
              _die.insert(j+1, newDie);
              j++;
            }
          }
        }
      }

      // if operator is keep (k) or drop (p)
      // [3, 3]kh1 must be [3], so program must keep track of what has been removed
      // [3, 3]kh1 = [3, 3]ph1 = [3, 3]kl1  = [3, 3]pl1 = [3]
      if (['k', 'p'].contains(setOp.op)) {
        List<int> setOpValues;
        if (setOp.op == 'k') {
          // discard the values not selected => keep the die in the inverted selection
          setOpValues = List<int>.from(listSubtraction(_keptDieValues, _getSetOpValues(setOp)));
          // print('k\'s setOpValues = $setOpValues');
        } else {
          // discard the selected values, keep the others
          setOpValues = _getSetOpValues(setOp);
          // print('p\'s setOpValues = $setOpValues');
        }
        for (var setOpValue in setOpValues) {
          // print('Checking setOpValue=$setOpValue');
          var aDiceHasBeenDiscarded = false;
          for (var d in _die) {
            if (d.kept && d.value == setOpValue && !aDiceHasBeenDiscarded) {
              // print('Discarding $d');
              d.discard();
              aDiceHasBeenDiscarded = true;
            }
          }
        }
      }
    }
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

  // List<int> _invertSetOpValues(List<int> setOpValues) {
  //   var outList = <int>[];
  //   for (var i = 1; i < _maxDieValue+1; i++) {
  //     if (!setOpValues.contains(i)) {
  //       outList.add(i);
  //     }
  //   }
  //   return outList;
  // }

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

void main() {
  var token = Token(TokenType.DICE, '3d20');
  var diceNode = DiceNode.fromToken(token);
  diceNode.addSetOp(SetOp('k', '>', 11));
  print(diceNode);
  diceNode.evaluate();
  print(diceNode);
  print(diceNode.value);
}