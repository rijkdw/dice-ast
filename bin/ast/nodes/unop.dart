import '../objects/token.dart';
import 'node.dart';

class UnOp extends Node {
  Token token, op;
  Node child;

  UnOp(this.token, this.child) {
    op = token;
  }
}