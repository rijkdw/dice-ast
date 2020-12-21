import 'utils.dart';

enum TokenType { integer, plus, minus, eof }

class Token {
  TokenType type;
  dynamic value;

  Token(this.type, this.value);

  @override
  String toString() => '$Token($type, $value)';
}

class Interpreter {
  String text;
  int pos = 0;
  Token currentToken;
  String currentChar;

  Interpreter(this.text) {
    currentChar = text[0];
  }

  // ===========================================================================
  // Lexer code
  // ===========================================================================

  void raiseError() {
    throw Exception('Invalid syntax');
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
        continue;
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
      raiseError();
    }
    return Token(TokenType.eof, null);
  }

  void eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = getNextToken();
    } else {
      raiseError();
    }
  }

  int term() {
    var token = currentToken;
    eat(TokenType.integer);
    return token.value;
  }

  int expr() {
    currentToken = getNextToken();
    var result = term();
    while ([TokenType.plus, TokenType.minus].contains(currentToken.type)) {
      var token = currentToken;
      if (token.type == TokenType.plus) {
        eat(TokenType.plus);
        result += term();
      } else if (token.type == TokenType.minus) {
        eat(TokenType.minus);
        result -= term();
      }
    }
    return result;
  }
}

void main() {
  var equations = ['2+3', '2+3+4', '6+10-3'];
  var interpreter;
  for (var equation in equations) {
    interpreter = Interpreter(equation);
    var result = interpreter.expr();
    print('$equation = $result');
  }
}
