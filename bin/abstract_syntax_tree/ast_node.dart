import '../utils.dart';
import 'die.dart';
import '../error.dart';
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
}

// =============================================================================
// MIXINS
// =============================================================================

// TODO?

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
}

class UnaryOpNode extends AstNode {
  Token token, op;
  AstNode expr;

  UnaryOpNode(this.token, this.expr) {
    op = token;
  }

  @override
  String toString() => 'UnaryOpNode(op=$op, child=$expr)';

  @override
  String visualise() => '${op.value}${expr.visualise()}';
}

class SetNode extends AstNode {
  Token token;
  List<AstNode> children;

  SetNode(this.token, this.children);

  @override
  String toString() {
    return 'SetNode(children=$children)';
  }

  @override
  String visualise() => '[' + join(children.map((c) => c.visualise()).toList(), ', ') + ']';
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

  Type getEventualChildType() {
    if (child is SetOpNode) {
      return (child as SetOpNode).getEventualChildType();
    }
    return child.runtimeType;
  }
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
}

class DiceNode extends AstNode {
  Token token;
  int number, size;
  List<Die> die;

  DiceNode(this.token, this.number, this.size) {
    _roll();
  }

  factory DiceNode.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return DiceNode(token, int.parse(matches.first), int.parse(matches.last));
  }

  _roll() {
    die = <Die>[];
    for (var i = 0; i < number; i++) {
      die.add(Die.roll(size));
    }
  }

  _explode(List<int> explodeValues) {
    for (var i = 0; i < die.length; i++) {
      var d = die[i];
      if (explodeValues.contains(d.value)) {
        // explode
        var dNew = Die.roll(size);
        die.insert(i+1, dNew);
      }
    }
  }

  @override
  String toString() => 'DiceNode(number=$number, size=$size, die=$die)';

  @override
  String visualise() => '${number}d${size}';

  @override
  int get value => sumList(die.map((d) => d.value).toList());
}

void main() {
  var token = Token(TokenType.DICE, '1d2');
  var diceNode = DiceNode.fromToken(token);
  print(diceNode);
  diceNode._explode([1]);
  print(diceNode);
}