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

  // @override
  // List<num> get possibilities {
  //   var returnList = <num>[];
  //   for (var leftPoss in left.possibilities) {
  //     for (var rightPoss in right.possibilities) {
  //       if (op.type == TokenType.PLUS) {
  //         returnList.add(leftPoss+rightPoss);
  //       }
  //       if (op.type == TokenType.MINUS) {
  //         returnList.add(leftPoss-rightPoss);
  //       }
  //       if (op.type == TokenType.MUL) {
  //         returnList.add(leftPoss*rightPoss);
  //       }
  //       if (op.type == TokenType.DIV) {
  //         returnList.add(leftPoss/rightPoss);
  //       }
  //     }
  //   }
  //   return returnList;
  // }

  @override
  Node get copy => BinOp(left.copy, token.copy, right.copy);

  // override Object methods

  @override
  String toString() => 'BinOp(left=$left, op=${op.value}, right=$right)';
}