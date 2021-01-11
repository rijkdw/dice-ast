import 'ast/objects/interpreter.dart';
import 'ast/objects/lexer.dart';
import 'ast/objects/parser.dart';
import 'ast/objects/result.dart';
import 'state.dart' as state;

class Roller {
  static Result roll(String expression) {
    state.numRollsMade = 0;
    var lexer = Lexer(expression);
    var parser = Parser(lexer);
    var interpreter = Interpreter(parser);
    var tree = interpreter.interpret();
    return Result(expression, tree);
  }

  /// Parse an expression multiple times, using the same
  /// AST for better time performance.
  static List<Result> rollN(String expression, int n) {
    var results = <Result>[];
    state.numRollsMade = 0;
    var parser = Parser(Lexer(expression));
    var tree = parser.parse();
    var interpreter = Interpreter(null);
    for (var i = 0; i < n; i++) {
      state.numRollsMade = 0;
      var copyOfTree = tree.copy;
      interpreter.interpretTree(copyOfTree);
      results.add(Result(expression, copyOfTree));
    }
    return results;
  }
}

void main() {

  var n = 100000;
  var expression = '1d20+3+1d4';

  // test time of multiple roll() calls
  var rollTime = 0; // milliseconds
  for (var i = 0; i < n; i++) {
    var startTime = DateTime.now().millisecondsSinceEpoch;
    Roller.roll(expression);
    var endTime = DateTime.now().millisecondsSinceEpoch;
    rollTime += endTime - startTime;
  }
  print('Calling Roller.roll($expression) $n times takes $rollTime ms.');

  // test time of one rollN() call
  var startTime = DateTime.now().millisecondsSinceEpoch;
  Roller.rollN(expression, n);
  var endTime = DateTime.now().millisecondsSinceEpoch;
  rollTime = endTime-startTime;
  print('Calling Roller.rollN($expression, $n) takes $rollTime ms.');
}