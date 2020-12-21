// =============================================================================
// TOKEN
// =============================================================================

import '../utils.dart';

enum TokenType { integer, plus, minus, mul, div, lpar, rpar, eof }

class Token {
  TokenType type;
  dynamic value;

  Token(this.type, this.value);

  @override
  String toString() => '$Token($type, $value)';
}

// =============================================================================
// ABSTRACT SYNTAX TREE
// =============================================================================

class AST {}

class BinOp extends AST {
  Token token, op;
  AST left, right;

  BinOp(this.left, this.op, this.right) {
    token = op;
  }
}

class UnaryOp extends AST {
  Token token, op;
  AST expr;

  UnaryOp(this.token, this.expr) {
    op = token;
  }
}

class Num extends AST {
  Token token;
  dynamic value;

  Num(this.token) {
    value = token.value;
  }
}

// =============================================================================
// LEXER
// =============================================================================

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
      if (currentChar == '(') {
        advance();
        return Token(TokenType.lpar, '(');
      }
      if (currentChar == ')') {
        advance();
        return Token(TokenType.rpar, ')');
      }
      raiseError();
    }
    return Token(TokenType.eof, null);
  }
}

// =============================================================================
// PARSER
// =============================================================================

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
    } else if (token.type == TokenType.integer) {
      eat(TokenType.integer);
      return Num(token);
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

// =============================================================================
// VISITOR
// =============================================================================

class NodeVisitor {
  Map<String, Function> functionMap;

  dynamic visit(AST node) {
    var functionName = 'visit${node.runtimeType}';
    var function = functionMap[functionName] ?? genericVisit;
    return function(node);
  }

  void genericVisit(AST node) {
    throw Exception('No visit${node.runtimeType}() method');
  }
}

class Interpreter extends NodeVisitor {
  Parser parser;

  Interpreter(this.parser) {
    functionMap = {
      'visitBinOp': visitBinOp,
      'visitNum': visitNum,
      'visitUnaryOp': visitUnaryOp,
    };
  }

  dynamic visitBinOp(BinOp node) {
    switch (node.op.type) {
      case TokenType.plus:
        return visit(node.left) + visit(node.right);
      case TokenType.minus:
        return visit(node.left) - visit(node.right);
      case TokenType.mul:
        return visit(node.left) * visit(node.right);
      case TokenType.div:
        return visit(node.left) ~/ visit(node.right);
    }
  }

  dynamic visitNum(Num node) {
    return node.value;
  }

  dynamic visitUnaryOp(UnaryOp node) {
    var op = node.op.type;
    if (op == TokenType.plus) {
      return visit(node.expr);
    } else if (op == TokenType.minus) {
      return -visit(node.expr);
    }
  }

  int interpret() {
    var tree = parser.parse();
    return visit(tree);
  }
}

void main() {
  print('Parsing of string inputs:');
  var lexer, parser, interpreter, result;
  var equations = ['5', '-5', '--5', '---5', '+5'];

  for (var equation in equations) {
    lexer = Lexer(equation);
    parser = Parser(lexer);
    interpreter = Interpreter(parser);
    result = interpreter.interpret();
    print('$equation = $result');
  }
}
