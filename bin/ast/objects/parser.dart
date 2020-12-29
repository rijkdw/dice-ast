import '../../utils.dart';
import '../nodes/binop.dart';
import '../nodes/dice.dart';
import '../nodes/literal.dart';
import '../nodes/node.dart';
import '../nodes/set.dart';
import '../nodes/setlike.dart';
import '../nodes/unop.dart';
import 'lexer.dart';
import 'setop.dart';
import 'token.dart';
import '../../error.dart' as error;

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

  Node expr() {
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
      node = BinOp(node, token, term());
    }
    return node;
  }

  Node term() {
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
      node = BinOp(node, token, factor());
    }
    return node;
  }

  Node factor() {
    _printStatus('factor()');
    // factor  : (PLUS|MINUS) factor | atom | LPAR expr RPAR
    var token = currentToken;

    // (PLUS|MINUS) factor
    if (currentToken.type == TokenType.PLUS) {
      eat(TokenType.PLUS);
      return UnOp(token, factor());
    } else if (currentToken.type == TokenType.MINUS) {
      eat(TokenType.MINUS);
      return UnOp(token, factor());
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

  Node atom() {
    _printStatus('atom()');
    // TODO
    // atom    : (((PLUS|MINUS) atom) | dice | set | literal) (setOp)*
    // set   : LPAR (expr (COMMA expr)* COMMA? )? RPAR
    var token = currentToken;
    Node node;

    // option 1: (PLUS | MINUS) atom
    if (token.type == TokenType.PLUS) {
      eat(TokenType.PLUS);
      node = UnOp(token, atom());
    } else if (token.type == TokenType.MINUS) {
      eat(TokenType.MINUS);
      node = UnOp(token, atom());
    }
    // option 2: dice
    else if (token.type == TokenType.DICE) {
      eat(TokenType.DICE);
      node = Dice.fromToken(token);
    }
    // option 3: set
    else if (token.type == TokenType.LPAR) {
      eat(TokenType.LPAR);
      // in the if-block, it's just "()"
      // -- the question-marked outer brackets happened 0 times
      if (currentToken.type == TokenType.RPAR) {
        eat(TokenType.RPAR);
        // the node has no children :(
        node = Set(null, []);
      }
      // in the else-block, it's everything else
      else {
        var setChildren = <Node>[];
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
        node = Set(null, setChildren);
      }
    }
    // option 4: literal
    else if (token.type == TokenType.REAL) {
      eat(TokenType.REAL);
      node = Literal(token);
    } else if (token.type == TokenType.INT) {
      eat(TokenType.INT);
      node = Literal(token);
    }
    _debugPrint(currentToken.toString());
    // (setOp)*
    while (currentToken.type == TokenType.SETOP_OP) {
      var op, sel, val;
      op = currentToken.value;
      eat(TokenType.SETOP_OP);
      if (currentToken.type == TokenType.SETOP_SEL) {
        sel = currentToken.value;
        eat(TokenType.SETOP_SEL);
      } else if (currentToken.type == TokenType.INT) {
        sel = '=';
      }
      val = currentToken.value;
      eat(TokenType.INT);
      var setOp = SetOp(op, sel, val);
      if (setOp.isInvalid) {
        error.raiseError(error.ErrorType.invalidSetOp, 'Invalid SetOp $setOp.');
      }
      if (node is SetLike) {
        node.addSetOp(setOp);
      }
    }

    return node;
  }

  // ignore: missing_return
  Node literal() {
    _printStatus('literal()');
    // literal   : REAL | INT
    var token = currentToken;
    if (token.type == TokenType.INT) {
      eat(TokenType.INT);
      return Literal(token);
    } else if (token.type == TokenType.REAL) {
      eat(TokenType.REAL);
      return Literal(token);
    }
    error.raiseError(error.ErrorType.unexpectedEndOfFunction);
  }

  Node parse() {
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
  var lexer = Lexer('(1, 2+3, 3d4, -5)kh1');
  var parser = Parser(lexer);
  var result = parser.parse();
  print(prettify(result));
}
