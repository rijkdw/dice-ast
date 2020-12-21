import '../utils.dart';

enum TokenType { integer, plus, minus, mul, div, eof }

class Token {
  TokenType type;
  dynamic value;

  Token(this.type, this.value);

  @override
  String toString() => '$Token($type, $value)';
}

class Lexer {
  String text;
  int pos = 0;
  String currentChar;

  Lexer(this.text) {
    currentChar = text[0];
  }

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
      if (currentChar == '*') {
        advance();
        return Token(TokenType.mul, '*');
      }
      if (currentChar == '/') {
        advance();
        return Token(TokenType.div, '/');
      }
      raiseError();
    }
    return Token(TokenType.eof, null);
  }
}

class Interpreter {
  Lexer lexer;
  Token currentToken;

  Interpreter(this.lexer) {
    currentToken = lexer.getNextToken();
  }

  void raiseError() {
    throw Exception('Invalid syntax');
  }

  void eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = lexer.getNextToken();
    } else {
      raiseError();
    }
  }

  int factor() {
    // factor : INT
    var token = currentToken;
    eat(TokenType.integer);
    return token.value;
  }

  int term() {
    // term : factor ( (MUL|DIV) factor ) *
    var result = factor();

    while ([TokenType.mul, TokenType.div].contains(currentToken.type)) {
      var token = currentToken;
      if (token.type == TokenType.mul) {
        eat(TokenType.mul);
        result *= factor();
      } else if (token.type == TokenType.div) {
        eat(TokenType.div);
        result ~/= factor();
      }
    }
    return result;
  }

  int expr() {
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
  var equations = ['2+3', '3/4+1*6', '1+2+3*6/3', '1*2*3*0+3*3-1*2'];
  var lexer, interpreter;
  for (var equation in equations) {
    lexer = Lexer(equation);
    interpreter = Interpreter(lexer);
    var result = interpreter.expr();
    print('$equation = $result');
  }
}
