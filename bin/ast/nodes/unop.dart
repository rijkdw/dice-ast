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

  // getters

  int get coefficient {
    if (op.type == TokenType.PLUS) {
      return 1;
    } else if (op.type == TokenType.MINUS) {
      return -1;
    }
    return 0;
  }

  // override Node methods

  @override
  int get value {
    return child.value * coefficient;
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

  // @override
  // List<num> get possibilities => child.possibilities.map((p) => p*coefficient).toList();

  @override
  Node get copy => UnOp(token.copy, child.copy);

  // override Object methods

  @override
  String toString() => 'UnOp(op=${op.value}, child=$child)';

}