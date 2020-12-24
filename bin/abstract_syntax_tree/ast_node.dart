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

  @override
  num get value {
    if (op.type == TokenType.PLUS) {
      return expr.value;
    }
    if (op.type == TokenType.MINUS) {
      return -expr.value;
    }
    return 0;
  }
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

  AstNode getEventualChild() {
    if (child is SetOpNode) {
      return (child as SetOpNode).getEventualChild();
    }
    return child;
  }

  SetOp get setOp => SetOp(op, sel, val);
}

class RootNode extends AstNode {
  AstNode node;

  RootNode(this.node);
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
  List<SetOp> setOps;

  DiceNode(this.token, this.number, this.size) {
    setOps = [];
    _roll();
  }

  factory DiceNode.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return DiceNode(token, int.parse(matches.first), int.parse(matches.last));
  }

  void _roll() {
    die = <Die>[];
    for (var i = 0; i < number; i++) {
      die.add(Die.roll(size));
    }
  }

  void _explode(List<int> explodeValues) {
    for (var i = 0; i < die.length; i++) {
      var d = die[i];
      if (explodeValues.contains(d.value)) {
        // explode
        var dNew = Die.roll(size);
        die.insert(i+1, dNew);
      }
    }
  }

  // set operators

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }

  @override
  String toString() => 'DiceNode(number=$number, size=$size, die=$die, setOps=$setOps)';

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