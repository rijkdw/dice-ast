import 'token.dart';
import '../utils.dart';

enum ErrorType {
  invalidSyntax,
}

String errorToString(ErrorType errorType) {
  return <ErrorType, String>{
    ErrorType.invalidSyntax: 'Invalid syntax',
  }[errorType];
}

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

  // raise an error for invalid syntax
  void raiseError({ErrorType errorType}) {
    throw Exception('Error -- ${errorToString(errorType)}');
  }

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

  dynamic real() {
    /**
     * A real number.
     */
    var result = '';
    while (currentChar != null && isDigit(currentChar)) {
      result += currentChar;
      advance();
    }

    // here, we either reach the decimal dot or something else.
    if (currentChar == '.') {
      result += '.';
      advance();
      while (currentChar != null && isDigit(currentChar)) {
        result += currentChar;
        advance();
      }
    } else {
      return int.parse(result);
    }
    return double.parse(result);
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
      // more complicated tokens get their own function, such as real()
      if (isDigit(currentChar)) {
        return Token(TokenType.real, real());
      }
      // plus
      if (currentChar == '+') {
        advance();
        return Token(TokenType.plus, '+');
      }
      // minus
      if (currentChar == '-') {
        advance();
        return Token(TokenType.minus, '-');
      }
      // multiply
      if (currentChar == '*') {
        advance();
        return Token(TokenType.mul, '*');
      }
      // divide
      if (currentChar == '/') {
        advance();
        return Token(TokenType.div, '/');
      }
      // left parenthesis
      if (currentChar == '(') {
        advance();
        return Token(TokenType.lpar, '(');
      }
      // right parenthesis
      if (currentChar == ')') {
        advance();
        return Token(TokenType.rpar, ')');
      }
      // comma
      if (currentChar == ',') {
        advance();
        return Token(TokenType.comma, ',');
      }
      // dice
      if (currentChar == 'd') {
        advance();
        return Token(TokenType.dice, 'd');
      }
      // if nothing matches, it's unrecognised and a syntax error is raised
      raiseError();
    }
    // end of the file default
    return Token(TokenType.eof, null);
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
    } while (token.type != TokenType.eof);
  }
}
