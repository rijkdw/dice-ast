import 'token.dart';
import '../../utils.dart';
import '../../error.dart' as error;

class Lexer {
  // ATTRIBUTES
  String text;
  int pos = 0;
  String currentChar;

  // CONSTRUCTOR
  Lexer(this.text) {
    text = text.replaceAll(' ', '');
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

  String peek([int offset]) {
    var peek_pos = pos + (offset ?? 1);
    if (peek_pos > text.length - 1) {
      return null;
    } else {
      return text[peek_pos];
    }
  }

  String get lookAhead => text.substring(pos);

  bool isDice() {
    var textAhead = lookAhead;
    var diceRegex = RegExp(r'^\d+d\d+');
    return diceRegex.hasMatch(textAhead);
  }

  bool isSet() {
    var textAhead = lookAhead;
    var atom = r'[a-z0-9,\+\-\/\*\(\)]+';
    var setRegexes = <String>[
      '\\( \\)',
      '\\( $atom , \\)',
      '\\( $atom , $atom (, $atom)* ,?\\)'
    ].map((regex) => "^(${regex.replaceAll(' ', '')})").toList();
    var setRegex = RegExp(join(setRegexes, '|'));
    return setRegex.hasMatch(textAhead)
        && ('('.allMatches(textAhead).length == ')'.allMatches(textAhead).length);
  }

  bool commaBeforeNextPar() {
    var peek_pos = pos+1;
    while (peek_pos < text.length-1 && text[peek_pos] != ')' && text[peek_pos] != '(') {
      if (text[peek_pos] == ',') {
        return true;
      }
      peek_pos++;
    }
    return false;
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

  Token dice() {
    /**
     * A dice (1d4, 5d6, 1d20).
     */

    var result = '';
    while (currentChar != null && isDigit(currentChar)) {
      result += currentChar;
      advance();
    }
    result += currentChar;
    advance();
    while (currentChar != null && isDigit(currentChar)) {
      result += currentChar;
      advance();
    }
    return Token(TokenType.DICE, result);
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
      // if a digit is present, it can either be a dice or a literal
      if (isDigit(currentChar)) {
        if (isDice()) {
          return dice();
        } else {
          return number();
        }
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
      // if (currentChar == 'd') {
      //   advance();
      //   return Token(TokenType.DICESEP, 'd');
      // }
      // set op operation
      if (['e', 'k', 'p', 'r', 'n', 'x', 'a', 'o'].contains(currentChar)) {
        var val = currentChar;
        advance();
        return Token(TokenType.SETOP_OP, val);
      }
      // set op selector
      if (['=', 'h', 'l', '>', '<'].contains(currentChar)) {
        var val = currentChar;
        advance();
        return Token(TokenType.SETOP_SEL, val);
      }
      // if nothing matches, it's unrecognised and a syntax error is raised
      error.raiseError(error.ErrorType.invalidSyntax);
    }
    // end of the file default
    return Token(TokenType.EOF, null);
  }
}

void main() {
  Lexer lexer;
  var texts = ['1d4', '1.5', '7', '(1, 2, 3)', '4+4d4+1', '4d6kh3'];
  for (var text in texts) {
    lexer = Lexer(text);
    print(text);
    Token token;
    do {
      token = lexer.getNextToken();
      print('$token -- \t${token.value}');
    } while (token.type != TokenType.EOF);
  }

  // dice separator tests
  print('\nDice separator tests');
  var diceSeparatorTests = ['1d4', '10d10', '1d20', '1d100', '1d', 'd4'];
  var diceSeparatorTestResults = [true, true, true, true, false, false];
  var diceSeparatorTestFails = 0;
  for (var i = 0; i < diceSeparatorTests.length; i++) {
    lexer = Lexer(diceSeparatorTests[i]);
    print(lexer.text);
    var result = lexer.isDice();
    print((result == diceSeparatorTestResults[i] ? 'Success' : 'Failure')
        + ' -- expected ${diceSeparatorTestResults[i]}, got $result.');
    if (result != diceSeparatorTestResults[i]) {
      diceSeparatorTestFails++;
    }
  }
  print(diceSeparatorTestFails == 0
      ? 'All dice tests passed.'
      : '$diceSeparatorTestFails dice test failures.'
  );

  // set tests
  print('\nSet tests');
  var setTests = <String, bool>{
    '()': true,
    '(1)': false,
    '(1d4)': false,
    '(1d4,)': true,
    '(,)': false,
    '((1), 1)': true,
    '((1,)': false,
    '(1, 1, 1d4)': true,
    '(1--3, (1+3, 2*1, 3)kh1)': true,

  };
  var setTestFails = 0;
  for (var test in setTests.keys) {
    var lexer = Lexer(test);
    var desiredResult = setTests[test];
    print(lexer.text);
    var obtainedResult = lexer.isSet();
    print((obtainedResult == desiredResult ? 'Success' : 'Failure')
        + ' -- expected ${desiredResult}, got $obtainedResult.');
    if (obtainedResult != desiredResult) {
      setTestFails++;
    }
  }
  print(setTestFails == 0
      ? 'All set tests passed.'
      : '$setTestFails set test failures.'
  );

  // comma tests
  print('\nComma set tests');
  var commaTests = <String, bool>{
    '(abc,(': true,
    '(abc,)': true,
    '(abc(': false,
  };
  var commaTestFails = 0;
  for (var test in commaTests.keys) {
    var lexer = Lexer(test);
    var desiredResult = commaTests[test];
    print(lexer.text);
    var obtainedResult = lexer.commaBeforeNextPar();
    print((obtainedResult == desiredResult ? 'Success' : 'Failure')
        + ' -- expected ${desiredResult}, got $obtainedResult.');
    if (obtainedResult != desiredResult) {
      commaTestFails++;
    }
  }
  print(commaTestFails == 0
      ? 'All comma tests passed.'
      : '$commaTestFails comma test failures.'
  );
}
