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

  Node expr() {
    // TODO
  }

  Node atom() {
    // TODO
    // atom    : ((PLUS|MINUS) atom | dice | set | literal) (setOp)*
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
    // TODO
    // set   : LPAR (atom (COMMA atom)* COMMA? )? RPAR
    eat(TokenType.LPAR);
    
    eat(TokenType.RPAR);
  }

  Node setOp() {
    // setOp  : operation seltype INT
  }

  Node parse() {
    return null;
  }
}

void main() {
  var expr = '()';
  var lexer = Lexer(expr);
  var parser = Parser(lexer);
  print(parser.set());
}
