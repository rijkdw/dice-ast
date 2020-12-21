import 'ast.dart';
import 'lexer.dart';
import 'token.dart';
import 'error.dart' as error;

class Parser {
  Lexer lexer;
  Token currentToken;

  Parser(this.lexer) {
    currentToken = lexer.getNextToken();
  }

  void eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = lexer.getNextToken();
    } else {
      error.raiseError();
    }
  }

  // AST functions for rules

  Node expr() {}

  Node atom() {
    // atom    : (PLUS|MINUS) atom | dice (setOp)* | set (setOp)* | literal
  }

  Node literal() {
    // literal   : REAL | INT
    var token = currentToken;
    if (token.type == TokenType.INT) {
      eat(TokenType.INT);
      return LiteralNode(token);
    } else if (token.type == TokenType.REAL) {
      eat(TokenType.REAL);
      return LiteralNode(token);
    }
  }

  Node dice() {
    // dice      : INT DICESEP INT
    var number = currentToken.value;
    eat(TokenType.INT);
    eat(TokenType.DICESEP);
    var size = currentToken.value;
    eat(TokenType.INT);
    return DiceNode(number, size);
  }

  Node set() {
    // set   : LPAR (atom (COMMA atom)* COMMA? )? RPAR
    var token = currentToken;
  }

  Node setOp() {
    // setOp   : operation selector
  }

  Node operation() {
    // operation   : k|p|e
  }

  Node selector() {
    // selector   : (s|h|l) INT
  }

  Node parse() {
    return null;
  }
}

void main() {
  var expr = '2';
  var lexer = Lexer(expr);
  var parser = Parser(lexer);
  print(parser.literal());
}
