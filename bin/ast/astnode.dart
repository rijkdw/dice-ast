import '../utils.dart';
import 'error.dart';
import 'token.dart';

class AstNode {
  String visualise() {
    raiseError(ErrorType.notImplemented);
  }
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
}

// =============================================================================
// LEAF NODES
// =============================================================================

class LiteralNode extends AstNode {
  Token token;
  dynamic value;

  LiteralNode(this.token) {
    value = token.value;
  }

  @override
  String toString() => 'LiteralNode(value=$value)';

  @override
  String visualise() => '${value}';
}

class DiceNode extends AstNode {
  Token token;
  int number, size;

  DiceNode(this.token, this.number, this.size);

  factory DiceNode.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return DiceNode(token, int.parse(matches.first), int.parse(matches.last));
  }

  @override
  String toString() => 'DiceNode(number=$number, size=$size)';

  @override
  String visualise() => '${number}d${size}';
}

void main() {
  var token = Token(TokenType.DICE, '10d3');
  print(DiceNode.fromToken(token));
}
