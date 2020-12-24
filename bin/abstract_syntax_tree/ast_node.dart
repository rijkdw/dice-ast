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

  void roll() {
    _die = <Die>[];
    for (var i = 0; i < number; i++) {
      _die.add(Die.roll(size));
    }
  }

  // set operators

  void addSetOp(SetOp setOp) {
    setOps.add(setOp);
  }

  @override
  String toString() => 'DiceNode(number=$number, size=$size, die=$_die, setOps=$setOps)';

  @override
  String visualise() => '${number}d${size}';

  @override
  int get value => sumList(_die.map((d) => d.value).toList());

  @override
  List<Die> get die => _die;
}

void main() {
  var token = Token(TokenType.DICE, '1d2');
  var diceNode = DiceNode.fromToken(token);
  print(diceNode);
}