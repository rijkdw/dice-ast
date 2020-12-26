import '../objects/token.dart';
import 'node.dart';

class BinOp extends Node {

  // attributes

  Token token, op;
  Node left, right;

  // constructor

  BinOp(this.left, this.op, this.right) {
    token = op;
  }

  // override Node methods

  @override
  int get value {
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
      return left.value ~/ right.value;
    }
    return 0;
  }

  // override Object methods

  @override
  String toString() => 'BinOp(left=$left, op=${op.value}, right=$right)';
}