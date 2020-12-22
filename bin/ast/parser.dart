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
    // expr  : term ((PLUS|MINUS) term)*
    var node = term();

    var operators = [TokenType.PLUS, TokenType.MINUS];
    while (operators.contains(currentToken.type)) {
      var token = currentToken;
      if (token.type == TokenType.PLUS) {
        eat(TokenType.PLUS);
      } else if (token.type == TokenType.MINUS) {
        eat(TokenType.MINUS);
      }
      node = BinOpNode(node, token, term());
    }
    return node;
  }

  Node term() {
    // term:  factor ((MUL|DIV) factor)*
    var node = factor();

    var operators = [TokenType.MUL, TokenType.DIV];
    while (operators.contains(currentToken.type)) {
      var token = currentToken;
      if (token.type == TokenType.MUL) {
        eat(TokenType.MUL);
      } else if (token.type == TokenType.DIV) {
        eat(TokenType.DIV);
      }
      node = BinOpNode(node, token, factor());
    }
    return node;
  }

  Node factor() {
    // factor  : (PLUS|MINUS) factor | atom | LPAR expr RPAR
    var token = currentToken;

    // ignore: missing_enum_constant_in_switch
    switch (currentToken.type) {
      case TokenType.PLUS:
        eat(TokenType.PLUS);
        return UnaryOpNode(token, factor());
      case TokenType.MINUS:
        eat(TokenType.MINUS);
        return UnaryOpNode(token, factor());
      case TokenType.INT:
        eat(TokenType.INT);
        return LiteralNode(token);
      case TokenType.LPAR:
        eat(TokenType.LPAR);
        var node = expr();
        eat(TokenType.RPAR);
        return node;
    }
  }

  Node atom() {
    // TODO
    // atom    : ((PLUS|MINUS) atom) | dice | set | literal (setOp)*
    var token = currentToken;

    // ignore: missing_enum_constant_in_switch
    switch (currentToken.type) {
      case TokenType.PLUS:
        eat(TokenType.PLUS);
        return UnaryOpNode(token, atom());
      case TokenType.MINUS:
        eat(TokenType.MINUS);
        return UnaryOpNode(token, atom());
    }
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
    // TODO
    // setOp  : operation seltype INT
  }

  Node parse() {
    return null;
  }
}

void main() {
  var expr = '(1+3)*25';
  var lexer = Lexer(expr);
  var parser = Parser(lexer);
  print(parser.expr());
}
