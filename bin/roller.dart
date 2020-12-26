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
}

void main() {
  var result = Roller.roll('4d6kh3');
  print(result);
  var die = result.die;
  print(die);
}