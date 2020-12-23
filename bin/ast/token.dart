enum TokenType {
  // generic
  REAL, // 1, 2, 3.14, 0.5
  INT, // 1, 2, 3
  DOT, // .
  COMMA, // ,
  DICESEP, // d
  
  LPAR, // (
  RPAR, // )
  EOF,
  // primitives
  DICE, // 1d4, 2d6, 10d8
  // SET, // (), (1,), (1,2,3), (1d4,3+3,1d20)
  // set operations
  SETOP_OP,
  SETOP_SEL,
  // binary operators
  PLUS, // +
  MINUS, // -
  MUL, // *
  DIV, // /
}

class Token {
  TokenType type;
  dynamic value;

  Token(this.type, this.value);

  @override
  String toString() => '$Token($type, \"$value\")';
}
