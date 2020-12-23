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

class BinOpAstNode extends AstNode {
  Token token, op;
  AstNode left, right;

  BinOpAstNode(this.left, this.op, this.right) {
    token = op;
  }

  @override
  String toString() => 'BinOpNode(left=$left, op=$op, right=$right)';

  @override
  String visualise() => '(${left.visualise()}${op.value}${right.visualise()})';
}

class UnaryOpAstNode extends AstNode {
  Token token, op;
  AstNode expr;

  UnaryOpAstNode(this.token, this.expr) {
    op = token;
  }

  @override
  String toString() => 'UnaryOpNode(op=$op, child=$expr)';

  @override
  String visualise() => '${op.value}${expr.visualise()}';
}

class SetAstNode extends AstNode {
  Token token;
  List<AstNode> children;

  SetAstNode(this.token, this.children);

  @override
  String toString() {
    return 'SetNode(children=$children)';
  }

  @override
  String visualise() => '[' + join(children.map((c) => c.visualise()).toList(), ', ') + ']';
}

class SetOpAstNode extends AstNode {
  String op, sel;
  int val;
  AstNode child;

  SetOpAstNode(this.child, this.op, this.sel, this.val);

  @override
  String toString() => 'SetOpNode(op=$op, sel=$sel, val=$val, child=$child)';

  @override
  String visualise() => '${child.visualise()}$op$sel$val';
}

// =============================================================================
// LEAF NODES
// =============================================================================

class LiteralAstNode extends AstNode {
  Token token;
  num value;

  LiteralAstNode(this.token) {
    value = token.value;
  }

  @override
  String toString() => 'LiteralNode(value=$value)';

  @override
  String visualise() => '${value}';
}

class DiceAstNode extends AstNode {
  Token token;
  int number, size;

  DiceAstNode(this.token, this.number, this.size);

  factory DiceAstNode.fromToken(Token token) {
    var diceRegex = RegExp(r'(\d+)d(\d+)');
    var matches = diceRegex.firstMatch(token.value).groups([1, 2]);
    return DiceAstNode(token, int.parse(matches.first), int.parse(matches.last));
  }

  @override
  String toString() => 'DiceNode(number=$number, size=$size)';

  @override
  String visualise() => '${number}d${size}';
}

void main() {
  var token = Token(TokenType.DICE, '10d3');
  print(DiceAstNode.fromToken(token));
}
