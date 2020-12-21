import 'token.dart';

class AST {}

class BinOp extends AST {
  Token token, op;
  AST left, right;

  BinOp(this.left, this.op, this.right) {
    token = op;
  }
}

class UnaryOp extends AST {
  Token token, op;
  AST expr;

  UnaryOp(this.token, this.expr) {
    op = token;
  }
}

class Number extends AST {
  Token token;
  dynamic value;

  Number(this.token) {
    value = token.value;
  }
}
