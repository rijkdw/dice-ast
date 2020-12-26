import '../objects/token.dart';
import 'node.dart';

class UnOp extends Node {

  // attributes

  Token token, op;
  Node child;

  // constructor

  UnOp(this.token, this.child) {
    op = token;
  }

  // override Node methods

  @override
  int get value {
    if (op.type == TokenType.PLUS) {
      return child.value;
    }
    if (op.type == TokenType.MINUS) {
      return -child.value;
    }
    return 0;
  }

  // override Object methods

  @override
  String toString() => 'UnOp(op=${op.value}, child=$child)';

}