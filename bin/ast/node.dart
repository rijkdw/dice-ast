import '../utils.dart';
import 'token.dart';

class Node {

  String visualise() {}

}

// =============================================================================
// MIXINS
// =============================================================================

// TODO?

// =============================================================================
// PARENT NODES
// =============================================================================

class BinOpNode extends Node {
  Token token, op;
  Node left, right;

  BinOpNode(this.left, this.op, this.right) {
    token = op;
  }

  @override
  String toString() => 'BinOpNode(left=$left, op=$op, right=$right)';

  @override
  String visualise() => '${left.visualise()}${op.value}${right.visualise()}';
}

class UnaryOpNode extends Node {
  Token token, op;
  Node expr;

  UnaryOpNode(this.token, this.expr) {
    op = token;
  }

  @override
  String toString() => 'UnaryOpNode(op=$op, child=$expr)';

  @override
  String visualise() => '${op.value}${expr.visualise()}';
}

class SetNode extends Node {
  Token token;
  List<Node> children;

  SetNode(this.token, this.children);

  @override
  String toString() {
    return 'SetNode(children=$children)';
  }

  @override
  String visualise() => '(' + join(children.map((c)=>c.visualise()).toList(), ', ') + ')';
}

class SetOpNode extends Node {
  // TODO
  Token token, op;
  Node setNode; // left
  Node selectorNode; // right

  SetOpNode(this.token, this.setNode, this.selectorNode) {
    op = token;
  }
}

class SelectorNode extends Node {
  // TODO
  // examples:  h3
  Token token;
  int value;

  SelectorNode(this.token, this.value);
}

// =============================================================================
// LEAF NODES
// =============================================================================

class LiteralNode extends Node {
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

class DiceNode extends Node {
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