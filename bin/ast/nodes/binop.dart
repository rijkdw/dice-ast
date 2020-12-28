import '../../utils.dart';
import '../objects/token.dart';
import 'die.dart';
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
  String visualise() => '${left.visualise()}${op.value}${right.visualise()}';

  @override
  List<Die> get die => left.die + right.die;

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