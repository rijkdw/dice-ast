import 'utils.dart';

enum TokenType { integer, plus, minus, eof }

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
  String currentChar;

  Interpreter(this.text) {
    pos = 0;
    currentToken = null;
    currentChar = text[pos];
  }

  void raiseError() {
    throw Exception('Error parsing input.');
  }

  void advance() {
    pos++;
    if (pos > text.length - 1) {
      currentChar = null;
    } else {
      currentChar = text[pos];
    }
  }

  void skipWhitespace() {
    while (currentChar != null && isSpace(currentChar)) {
      advance();
    }
  }

  int integer() {
    var result = '';
    while (currentChar != null && isDigit(currentChar)) {
      result += currentChar;
      advance();
    }
    return int.parse(result);
  }

  Token getNextToken() {
    while (currentChar != null) {
      if (isSpace(currentChar)) {
        skipWhitespace();
      }
      if (isDigit(currentChar)) {
        return Token(TokenType.integer, integer());
      }
      if (currentChar == '+') {
        advance();
        return Token(TokenType.plus, '+');
      }
      if (currentChar == '-') {
        advance();
        return Token(TokenType.minus, '-');
      }
      return Token(TokenType.eof, null);
    }
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
    if (op.type == TokenType.plus) {
      eat(TokenType.plus);
    } else {
      eat(TokenType.minus);
    }

    var right = currentToken;
    eat(TokenType.integer);

    var result;
    if (op.type == TokenType.plus) {
      result = left.value + right.value;
    } else {
      result = left.value - right.value;
    }
    return result;
  }
}

// MAIN FUNCTION

void main() {
  var equations = ['3+5', '27+5', '27-5'];
  var interpreter;
  for (String equation in equations) {
    interpreter = Interpreter(equation);
    var result = interpreter.expr();
    print('$equation = $result');
  }
}
