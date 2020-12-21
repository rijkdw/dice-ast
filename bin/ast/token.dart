enum TokenType {
  real,     // 1, 2, 3.14, 0.5
  integer,  // 1, 2, 3
  dot,      // .
  comma,    // ,
  dice,     // d
  plus,     // +
  minus,    // -
  mul,      // *
  div,      // /
  lpar,     // (
  rpar,     // )
  eof,
}

class Token {
  TokenType type;
  dynamic value;

  Token(this.type, this.value);

  @override
  String toString() => '$Token($type, $value)';
}
