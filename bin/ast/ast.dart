import 'token.dart';

class Node {}

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
}

class UnaryOpNode extends Node {
  Token token, op;
  Node expr;

  UnaryOpNode(this.token, this.expr) {
    op = token;
  }
}

class SetOpNode extends Node {
  Token token, op;
  Node setNode; // left
  Node selectorNode; // right

  SetOpNode(this.token, this.setNode, this.selectorNode) {
    op = token;
  }
}

class SelectorNode extends Node {
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
}

class DiceNode extends Node {
  Token token;
  int number, size;

  DiceNode(this.number, this.size);

  @override
  String toString() => 'DiceNode(number=$number, size=$size)';
}
