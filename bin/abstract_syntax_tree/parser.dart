import 'ast_node.dart';
import 'lexer.dart';
import 'token.dart';
import '../error.dart' as error;

class Parser {
  Lexer lexer;
  Token currentToken;
  bool verbose;

  Parser(this.lexer, {this.verbose=false}) {
    currentToken = lexer.getNextToken();
  }

  void eat(TokenType type) {
    if (currentToken.type == type) {
      currentToken = lexer.getNextToken();
    } else {
      error.raiseError(
        error.ErrorType.eatError,
        'Expected $type, but found ${currentToken.type}'
      );
    }
  }

  // AST functions for rules

  AstNode expr() {
    _printStatus('expr()');
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

  AstNode term() {
    _printStatus('term()');
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

  AstNode factor() {
    _printStatus('factor()');
    // factor  : (PLUS|MINUS) factor | atom | LPAR expr RPAR
    var token = currentToken;

    // (PLUS|MINUS) factor
    if (currentToken.type == TokenType.PLUS) {
      eat(TokenType.PLUS);
      return UnaryOpNode(token, factor());
    } else if (currentToken.type == TokenType.MINUS) {
      eat(TokenType.MINUS);
      return UnaryOpNode(token, factor());
    // atom
    } else if ([TokenType.INT, TokenType.REAL, TokenType.DICE].contains(currentToken.type) || lexer.commaBeforeNextPar()) {
      _debugPrint('Parser.factor() thinks this is an atom');
      return atom();
    // LPAR expr RPAR
    } else if (currentToken.type == TokenType.LPAR) {
      eat(TokenType.LPAR);
      var node = expr();
      eat(TokenType.RPAR);
      return node;
    }
    // we got a problem now
    error.raiseError(error.ErrorType.unexpectedEndOfFunction, 'Last token is $currentToken.');
  }

  AstNode atom() {
    _printStatus('atom()');
    // TODO
    // atom    : (((PLUS|MINUS) atom) | dice | set | literal) (setOp)*
    // set   : LPAR (expr (COMMA expr)* COMMA? )? RPAR
    var token = currentToken;
    AstNode node;

    // option 1: (PLUS | MINUS) atom
    if (token.type == TokenType.PLUS) {
      eat(TokenType.PLUS);
      node = UnaryOpNode(token, atom());
    } else if (token.type == TokenType.MINUS) {
      eat(TokenType.MINUS);
      node = UnaryOpNode(token, atom());
    }
    // option 2: dice
    else if (token.type == TokenType.DICE) {
      eat(TokenType.DICE);
      node = DiceNode.fromToken(token);
    }
    // option 3: set
    else if (token.type == TokenType.LPAR) {
      eat(TokenType.LPAR);
      // in the if-block, it's just "()"
      // -- the question-marked outer brackets happened 0 times
      if (currentToken.type == TokenType.RPAR) {
        eat(TokenType.RPAR);
        // the node has no children :(
        node = SetNode(null, []);
      }
      // in the else-block, it's everything else
      else {
        var setChildren = <AstNode>[];
        // one expr()
        setChildren.add(expr());
        // (COMMA expr)*
        while (currentToken.type == TokenType.COMMA) {
          eat(TokenType.COMMA);
          setChildren.add(expr());
        }
        // COMMA?
        if (currentToken.type == TokenType.COMMA) {
          eat(TokenType.COMMA);
        }
        // at the very end, consume a RPAR
        eat(TokenType.RPAR);
        // and return the finished node
        node = SetNode(null, setChildren);
      }
    }
    // option 4: literal
    else if (token.type == TokenType.REAL) {
      eat(TokenType.REAL);
      node = LiteralNode(token);
    } else if (token.type == TokenType.INT) {
      eat(TokenType.INT);
      node = LiteralNode(token);
    }
    _debugPrint(currentToken.toString());
    // (setOp)*
    while (currentToken.type == TokenType.SETOP_OP) {
      var op = currentToken.value;
      eat(TokenType.SETOP_OP);
      var sel = currentToken.value;
      eat(TokenType.SETOP_SEL);
      var val = currentToken.value;
      eat(TokenType.INT);
      node = SetOpNode(node, op, sel, val);
    }

    return node;

    // switch (token.type) {
    //   // option 1: (PLUS | MINUS) atom
    //   case TokenType.PLUS:
    //     eat(TokenType.PLUS);
    //     return UnaryOpNode(token, atom());
    //   case TokenType.MINUS:
    //     eat(TokenType.MINUS);
    //     return UnaryOpNode(token, atom());
    //   // option 2: dice
    //   case TokenType.DICE:
    //     eat(TokenType.DICE);
    //     return DiceNode.fromToken(token);
    //   // option 3: set
    //   case TokenType.LPAR:
    //     eat(TokenType.LPAR);
    //     // in the if-block, it's just "()"
    //     // -- the question-marked outer brackets happened 0 times
    //     if (currentToken.type == TokenType.RPAR) {
    //       eat(TokenType.RPAR);
    //     }
    //     // in the else-block, it's everything else
    //     else {
    //       var setChildren = <AstNode>[];
    //       // one expr()
    //       setChildren.add(expr());
    //       // (COMMA expr)*
    //       while (currentToken.type == TokenType.COMMA) {
    //         eat(TokenType.COMMA);
    //         setChildren.add(expr());
    //       }
    //       // COMMA?
    //       if (currentToken.type == TokenType.COMMA) {
    //         eat(TokenType.COMMA);
    //       }
    //       // at the very end, consume a RPAR
    //       eat(TokenType.RPAR);
    //       // and return the finished node
    //       return SetNode(null, setChildren);
    //     }
    //     break;
    //   // option 4: literal
    //   case TokenType.REAL:
    //     eat(TokenType.REAL);
    //     return LiteralNode(token);
    //   case TokenType.INT:
    //     eat(TokenType.INT);
    //     return LiteralNode(token);
    // }
    
    // error.raiseError(error.ErrorType.unexpectedEndOfFunction);
  }

  // ignore: missing_return
  AstNode literal() {
    _printStatus('literal()');
    // literal   : REAL | INT
    var token = currentToken;
    if (token.type == TokenType.INT) {
      eat(TokenType.INT);
      return LiteralNode(token);
    } else if (token.type == TokenType.REAL) {
      eat(TokenType.REAL);
      return LiteralNode(token);
    }
    error.raiseError(error.ErrorType.unexpectedEndOfFunction);
  }

  AstNode parse() {
    _printStatus('parse()');
    return expr();
  }

  static bool canParse(String testText) {
    var testLexer = Lexer(testText);
    var testParser = Parser(testLexer);
    try {
      testParser.parse();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _debugPrint(String msg) {
    if (verbose) {
      print(msg);
    }
  }

  void _printStatus(String functionName)  {
    _debugPrint('> $functionName\n  currentToken=$currentToken\n  lookahead=\"${lexer.lookAhead}\"');
  }
}

void main() {
  var expressions = <String>[
    // basic arithmetic
    '1',
    '10',
    '1+12',
    '1-1',
    '1-+-3',
    '2*(7+3)+2*(2*(6+8)+1)',
    // dice
    '1d4',
    '10d20',
    // dice with set ops
    '4d6kh3',
    '4d6kh3kh2',
    '10d6k>2',
    // sets
    '(1)',
    '(1,2)',
    '(1, 3,    20)',
    '(1,1d4,1d12)',
    '(1, 2+2, 3*2*(2+1), (1, 2, 3), 1d20+3)',
    // sets with set ops
    '(1,2,3)kh1',
    '2d6'
  ];
  Lexer lexer;
  Parser parser;

  for (var expr in expressions) {
    lexer = Lexer(expr);
    parser = Parser(lexer);
    if (Parser.canParse(expr)) {
      var result = parser.parse();
      print('$expr:\n  Success\n  ${result}\n  Visualised as ${result.visualise()}');
    }
    else {
      print('$expr:\n  Failure');
    }
  }

}
