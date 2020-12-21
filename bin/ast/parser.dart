import 'ast.dart';
import 'lexer.dart';
import 'token.dart';

class Parser {
  Lexer lexer;
  Token currentToken;

  Parser(this.lexer) {
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

  AST factor() {
    // factor : (PLUS|MIN) factor | INT | LPAR expr RPAR
    var token = currentToken;
    if (token.type == TokenType.plus) {
      eat(TokenType.plus);
      var node = UnaryOp(token, factor());
      return node;
    } else if (token.type == TokenType.minus) {
      eat(TokenType.minus);
      var node = UnaryOp(token, factor());
      return node;
    } else if (token.type == TokenType.real) {
      eat(TokenType.real);
      return Number(token);
    } else if (token.type == TokenType.lpar) {
      eat(TokenType.lpar);
      var node = expr();
      eat(TokenType.rpar);
      return node;
    }
  }

  AST term() {
    // term : factor ( (MUL|DIV) factor ) *
    var node = factor();
    while ([TokenType.mul, TokenType.div].contains(currentToken.type)) {
      var token = currentToken;
      if (token.type == TokenType.mul) {
        eat(TokenType.mul);
      } else if (token.type == TokenType.div) {
        eat(TokenType.div);
      }
      node = BinOp(node, token, factor());
    }
    return node;
  }

  AST expr() {
    // expr : term ( (PLUS|MINUS) term) *
    var node = term();
    while ([TokenType.plus, TokenType.minus].contains(currentToken.type)) {
      var token = currentToken;
      if (token.type == TokenType.plus) {
        eat(TokenType.plus);
      } else if (token.type == TokenType.minus) {
        eat(TokenType.minus);
      }
      node = BinOp(node, token, term());
    }
    return node;
  }

  AST parse() => expr();
}