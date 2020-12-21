import '../utils.dart';

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
    pos = 0;
    currentToken = null;
  }

  void raiseError() {
    throw Exception('Error parsing input.');
  }

  Token getNextToken() {
    if (pos > text.length - 1) {
      return Token(TokenType.eof, null);
    }
    var currentChar = text[pos];
    if (isDigit(currentChar)) {
      var token = Token(TokenType.integer, int.parse(currentChar));
      pos++;
      return token;
    }
    if (currentChar == '+') {
      var token = Token(TokenType.plus, currentChar);
      pos++;
      return token;
    }
    raiseError();
    return null;
  }

  void eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = getNextToken();
    } else {
      raiseError();
    }
  }

  dynamic expr() {
    currentToken = getNextToken();
    var left = currentToken;
    eat(TokenType.integer);

    var op = currentToken;
    eat(TokenType.plus);

    var right = currentToken;
    eat(TokenType.integer);

    int result = left.value + right.value;
    return result;
  }
}

// MAIN FUNCTION

void main() {
  var interpreter = Interpreter('3+5');
  int result = interpreter.expr();
  print('${result}');
}
