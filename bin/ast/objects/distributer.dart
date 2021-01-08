import '../../utils.dart';
import 'interpreter.dart';
import 'lexer.dart';
import 'parser.dart';

class Distributer {

  static Map<int, int> getDistribution(String expression) {
    var tree = Interpreter(Parser(Lexer(expression))).interpret();
    var possibilities = tree.possibilities;
    var possibilitiesAsSet = possibilities.toSet();
    var map = <int, int>{};
    for (var key in possibilitiesAsSet) {
      map[key] = countInList(possibilities, key);
    }
    return map;
  }

}

void main() {
  print(prettify(Distributer.getDistribution('8d6').toString()));
}