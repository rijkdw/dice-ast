import '../objects/token.dart';
import 'die.dart';
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

  @override
  String visualise() => '${op.value}${child.visualise()}';

  @override
  List<Die> get die => child.die;

  // override Object methods

  @override
  String toString() => 'UnOp(op=${op.value}, child=$child)';

}