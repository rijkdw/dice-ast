import 'token.dart';
import '../utils.dart';
import 'error.dart' as error;

class Lexer {
  // ATTRIBUTES
  String text;
  int pos = 0;
  String currentChar;

  // CONSTRUCTOR
  Lexer(this.text) {
    currentChar = text[0];
  }

  // FUNCTIONS

  void advance() {
    /**
     * Move one step forward and update the current character.
     */
    pos++;
    if (pos > text.length - 1) {
      currentChar = null;
    } else {
      currentChar = text[pos];
    }
  }

  void skipWhitespace() {
    /**
     * Skip whitespace in the expression.
    */
    while (currentChar != null && isSpace(currentChar)) {
      advance();
    }
  }

  Token number() {
    /**
     * A real number.
     */
    var result = '';
    while (currentChar != null && isDigit(currentChar)) {
      result += currentChar;
      advance();
    }

    // here, we either reach the decimal dot (which means it is a real value)...
    if (currentChar == '.') {
      result += '.';
      advance();
      while (currentChar != null && isDigit(currentChar)) {
        result += currentChar;
        advance();
      }
    } else {
      // ...or we've reached an integer
      return Token(TokenType.INT, int.parse(result));
    }
    // return the double constructed in the above if clause body.
    return Token(TokenType.REAL, double.parse(result));
  }

  Token getNextToken() {
    /**
     * Get the next token in the text.
     * 
     */
    while (currentChar != null) {
      // if whitespace, skip it
      if (isSpace(currentChar)) {
        skipWhitespace();
        continue;
      }
      // more complicated tokens get their own function, such as number()
      if (isDigit(currentChar)) {
        return number();
      }
      // plus
      if (currentChar == '+') {
        advance();
        return Token(TokenType.PLUS, '+');
      }
      // minus
      if (currentChar == '-') {
        advance();
        return Token(TokenType.MINUS, '-');
      }
      // multiply
      if (currentChar == '*') {
        advance();
        return Token(TokenType.MUL, '*');
      }
      // divide
      if (currentChar == '/') {
        advance();
        return Token(TokenType.DIV, '/');
      }
      // left parenthesis
      if (currentChar == '(') {
        advance();
        return Token(TokenType.LPAR, '(');
      }
      // right parenthesis
      if (currentChar == ')') {
        advance();
        return Token(TokenType.RPAR, ')');
      }
      // comma
      if (currentChar == ',') {
        advance();
        return Token(TokenType.COMMA, ',');
      }
      // dice
      if (currentChar == 'd') {
        advance();
        return Token(TokenType.DICESEP, 'd');
      }
      // if nothing matches, it's unrecognised and a syntax error is raised
      error.raiseError();
    }
    // end of the file default
    return Token(TokenType.EOF, null);
  }
}

void main() {
  Lexer lexer;
  var texts = ['1d4', '1.5', '7', '(1, 2, 3)'];
  for (var text in texts) {
    lexer = Lexer(text);
    print(text);
    Token token;
    do {
      token = lexer.getNextToken();
      print('$token -- \t${token.value}');
    } while (token.type != TokenType.EOF);
  }
}
