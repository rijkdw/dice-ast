import 'package:collection/collection.dart';

import 'ast/nodes/dice.dart';
import 'ast/nodes/set.dart';
import 'ast/nodes/setlike.dart';
import 'ast/objects/interpreter.dart';
import 'ast/objects/lexer.dart';
import 'ast/objects/parser.dart';
import 'roller.dart';
import 'utils.dart';
import 'state.dart' as state;

class Test {

  String name;
  int repeats;
  bool Function() testCallback;
  bool _success;

  Test(this.name, this.testCallback, {this.repeats=1});

  void performTest() {
    var failures = 0;
    for (var i = 0; i < repeats; i++) {
      state.numRollsMade = 0;
      if (!testCallback()) {
        failures++;
      }
    }
    _success = failures == 0;
  }

  bool get success => _success;
  bool get failure => !success;

}

class TestsList {

  List<Test> tests;

  TestsList(this.tests);

  int get count => tests.length;
  int get countSuccesses {
    var c = 0;
    tests.forEach((test) => c += test.success ? 1 : 0);
    return c;
  }
  int get countFailures => count - countSuccesses;

  bool get hasFailures => countFailures > 0;

  List<String> get failureNames {
    var list = <String>[];
    tests.forEach((test) {
      if (test.failure) list.add(test.name);
    });
    return list;
  }

  void performTests() {
    tests.forEach((test) => test.performTest());
  }

  void printLog() {
    if (countFailures == 0) {
      print('All $count tests passed.');
    } else {
      // print number of failures out of total
      print('$countFailures out of $count tests failed.');
      // print failed tests
      print('Failed tests:');
      print(join(failureNames, '\n'));
    }
    
  }

}

void main() {
  var tests = TestsList([

    Test('Test-test.', () {
      var result = 123;
      return result*2 == 246;
    }),

    Test('Arithmetic', () {
      var result = Roller.roll('1+2*3+(3-1)*2').rootNode;
      return result.value == 11;
    }),

    Test('Arithmetic + sets', () {
      var result = Roller.roll('2*3+((1, 2, 3)+4)*2').rootNode;
      return result.value == 26;
    }),

    Test('Arithmetic + sets + setops', () {
      var result = Roller.roll('2*3+((1, 2, 3)kh2+4)*2').rootNode;
      return result.value == 24;
    }),

    Test('Set evaluation', () {
      var result = Roller.roll('(1, 2, 3)').rootNode;
      return result.value == 6;
    }),

    Test('Set evaluation with dice', () {
      var result = Roller.roll('(1, 4d4)').rootNode;
      // print(result.value);
      return makeList(5, 17).contains(result.value);
    }, repeats: 10000),

    Test('Keeping 3 out of 4 dice.', () {
      var result = Roller.roll('4d6kh3').rootNode;
      var threeRemain = (result as Dice).keptChildren.length == 3;
      var lowestDropped = 
          (result as SetLike).discardedChildren.length == 1 &&
          (result as SetLike).discardedChildren.first.value <= (result as Dice).keptChildren[0].value &&
          (result as SetLike).discardedChildren.first.value <= (result as Dice).keptChildren[1].value &&
          (result as SetLike).discardedChildren.first.value <= (result as Dice).keptChildren[2].value;
      return threeRemain && lowestDropped;
    }, repeats: 100),

    Test('Stat rolling within range of 3 - 18.', () {
      var result = Roller.roll('4d6kh3').rootNode;
      var stat = result.value;
      return makeList(3, 18).contains(stat);
    }, repeats: 10000),

    Test('Keeping 2 out of 3 in a set', () {
      var result = Roller.roll('(1, 2+1, 2*2)kh2').rootNode;
      return listEquality((result as Set).keptChildrenValues, [3,4]);
    }),

    Test('Keep/drop of identical values', () {
      var result = Roller.roll('(1, 1, 2, 3)kh3').rootNode;
      return listEquality((result as Set).keptChildrenValues, [1, 2, 3]);
    }),

    Test('Middle-vantage', () {
      var result = Roller.roll('3d20kh2ph1').rootNode;
      var allThreeValues = (result as SetLike).children.map((c) => c.value).toList();
      allThreeValues.sort();
      return result.value == allThreeValues[1];
    }, repeats: 100),

    Test('Explosions 1', () {
      var result = Roller.roll('4d6e>3').rootNode;
      var die = (result as Dice).die;
      for (var d in die) {
        if (d.value > 3 && !d.exploded) return false;
        if (d.value <= 3 && d.exploded) return false;
      }
      return true;
    }, repeats: 100),

    Test('Explosions 2', () {
      var result = Roller.roll('4d6e<3').rootNode;
      var die = (result as Dice).die;
      for (var d in die) {
        if (d.value < 3 && !d.exploded) return false;
        if (d.value >= 3 && d.exploded) return false;
      }
      return true;
    }, repeats: 100),

    Test('Explosions 3', () {
      var result = Roller.roll('4d6e1e3e5').rootNode;
      var die = (result as Dice).die;
      for (var d in die) {
        if ([1, 3, 5].contains(d.value) && !d.exploded) return false;
        if (![1, 3, 5].contains(d.value) && d.exploded) return false;
      }
      return true;
    }, repeats: 100),

    Test('Reroll 1', () {
      var result = Roller.roll('1d4r>1').rootNode;
      var die = (result as Dice).die;
      for (var d in die) {
        if (d.value > 1 && d.isKept) return false;
      }
      return true;
    }, repeats: 100),

    Test('Reroll and add', () {
      var result = Roller.roll('1d4a4').rootNode;
      var die = (result as Dice).die;
      if (die.first.value == 4) {
        if (die.first.isDiscarded) return false;
        if (die.length < 2) return false;
      }
      return true;
    }, repeats: 100),

    Test('Reroll once', () {
      var result = Roller.roll('1d4o4').rootNode;
      var die = (result as Dice).die;
      if (die.first.value == 4) {
        if (die.first.isKept) return false;
        if (die.length < 2) return false;
      }
      return true;
    }, repeats: 100),

    Test('Minimum', () {
      var result = Roller.roll('10d20n19').rootNode;
      var die = (result as Dice).die;
      for (var d in die) {
        if (d.value < 19) return false;
      }
      return true;
    }, repeats: 100),

    Test('Maximum', () {
      var result = Roller.roll('10d20x2').rootNode;
      var die = (result as Dice).die;
      for (var d in die) {
        if (d.value > 2) return false;
      }
      return true;
    }, repeats: 100),

    Test('Die returning', () {
      var result = Roller.roll('(3d6, 4d10, 1d20)+2d4').rootNode;
      var die = result.die;
      return die.length == 10;
    }, repeats: 100),

    Test('Invalid setops', () {
      var expression = '1d20n>1';
      return !Parser.canParse(expression);
    }),

    Test('Roller.rollN() method', () {
      var results = Roller.rollN('4d6kh3', 100);
      var totals = results.map((result) => result.total).toList();
      totals.forEach((total) {
        if (total > 18 || total < 3) {
          return false;
        }
      });
      return true;
    }, repeats: 100),

    Test('Roller.rollN() is faster than Roller.roll()', () {
      var expression = '4d6kh3';
      var n = 100;
      var rollOneTime = time(() {
        for (var i = 0; i < n; i++) {Roller.roll(expression);}
      });
      var rollN = time(() {
        Roller.rollN(expression, n);
      });
      return rollN < rollOneTime;
    }, repeats: 1000),

    Test('Roller.rollN() gives correct answers', () {
      var expression = '4d6kh3';
      var numRepeats = 100;
      var results = Roller.rollN(expression, numRepeats);
      var totals = results.map((r) => r.total);
      totals.forEach((t) {
        print(t);
        if (t > 18 || t < 3) return false;
      });
      return true;
    }, repeats: 1000)

    // Test('Distribution 1', () {
    //   var interpreter = Interpreter(Parser(Lexer('2d6')));
    //   var tree = interpreter.interpret();
    //   var poss = tree.possibilities;
    //   poss.sort();
    //   print(poss);
    //   return false;
    // }),

    // Test('Absurd expression 1', () {
    //   var expression = '4d2e>1kh1e2';
    //   var result = Roller.roll(expression).rootNode;
    //   print('===========================');
    //   print(prettify(result.die));
    //   return true;
    // }, repeats: 3)

  ]);

  tests.performTests();
  tests.printLog();

}