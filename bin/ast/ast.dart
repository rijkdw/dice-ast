import 'token.dart';

class Node {}

class BinOpNode extends Node {
  Token token, op;
  Node left, right;

  BinOpNode(this.left, this.op, this.right) {
    token = op;
  }
}

class UnaryOpNode extends Node {
  Token token, op;
  Node expr;

  UnaryOpNode(this.token, this.expr) {
    op = token;
  }
}

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
