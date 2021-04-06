// import '../../utils.dart';
// import 'interpreter.dart';
// import 'lexer.dart';
// import 'parser.dart';
// import '../../state.dart' as state;

// class Distribution {

//   String expression;
//   List<int> possibilities;
//   Map<int, int> countMap;
//   Map<int, double> percMap;

//   Distribution(this.expression, this.possibilities, this.countMap, this.percMap);

//   factory Distribution.fromExpression(String expression) {
//     var tree = Interpreter(Parser(Lexer(expression))).interpret();
//     var possibilities = List<int>.from(tree.possibilities);
//     var countMap = _getCountMapFromList(possibilities);
//     var percMap = _countMap2percMap(countMap);
//     return Distribution(expression, possibilities, countMap, percMap);
//   }

//   static Map<int, int> _getCountMapFromList(List<int> possibilities) {
//     var possibilitiesAsSet = possibilities.toSet();
//     var map = <int, int>{};
//     for (var key in possibilitiesAsSet) {
//       map[key] = countInList(possibilities, key);
//     }
//     return map;
//   }

//   static Map<int, double> _countMap2percMap(Map<int, int> countMap) {
//     var totalCount = sumList(countMap.values.toList());
//     var percMap = <int, double>{};
//     for (var key in countMap.keys) {
//       percMap[key] = countMap[key] / totalCount * 100;
//     }
//     return percMap;
//   }

//   @override
//   String toString() {
//     return 'Distribution(countMap=$countMap, percMap = $percMap)';
//   }

// }

// void main() {
//   for (var i = 1; i <= 7; i++) {
//     var totalTimeTaken = 0; // in milliseconds
//     for (var loop = 0; loop < 100; loop++) {
//       var startTime = DateTime.now().millisecondsSinceEpoch;
//       Distribution.fromExpression('${i}d6');
//       state.numRollsMade = 0;
//       var endTime = DateTime.now().millisecondsSinceEpoch;
//       totalTimeTaken += endTime - startTime;
//     }
//     print('${i}d6: ${totalTimeTaken/100} ms avg over 100 loops');
//   }
// }