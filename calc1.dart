enum TokenType { integer, plus, eof }

// Token class
class Token {
  TokenType type;
  dynamic value;

  Token(this.type, this.value);
}

// Interpreter class
class Interpreter {
  String text;
  int pos;
  Token currentToken;

  Interpreter(this.text) {
    this.pos = 0;
    this.currentToken = null;
  }

  void error() {
    throw Exception("Error parsing input.");
  }

  Token getNextToken() {
    if (this.pos > this.text.length - 1) return Token(TokenType.eof, null);

    String currentChar = this.text[this.pos];
    if (isDigit(currentChar)) {
      Token token = Token(TokenType.integer, int.parse(currentChar));
      this.pos++;
      return token;
    }
    if (currentChar == "+") {
      Token token = Token(TokenType.plus, currentChar);
      this.pos++;
      return token;
    }
    this.error();
  }

  void eat(TokenType type) {
    if (this.currentToken.type == type) {
      this.currentToken = this.getNextToken();
    } else {
      this.error();
    }
  }

  dynamic expr() {
    this.currentToken = this.getNextToken();
    Token left = this.currentToken;
    this.eat(TokenType.integer);

    Token op = this.currentToken;
    this.eat(TokenType.plus);

    Token right = this.currentToken;
    this.eat(TokenType.integer);

    int result = left.value + right.value;
    return result;
  }
}

// MAIN FUNCTION

void main() {
  Interpreter interpreter = Interpreter("3+5");
  int result = interpreter.expr();
  print("${result}");
}

// HELPER FUNCTIONS

bool isDigit(String s) {
  if (s == null) return false;
  if (s.length > 1) return false;
  return double.parse(s, (e) => null) != null;
}
