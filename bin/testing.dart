import 'ast/nodes/dice.dart';
import 'ast/nodes/set.dart';
import 'ast/nodes/setlike.dart';
import 'ast/objects/interpreter.dart';
import 'ast/objects/lexer.dart';
import 'ast/objects/parser.dart';
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
    }, repeats: 100),

    Test('Arithmetic', () {
      var result = Interpreter(Parser(Lexer('1+2*3+(3-1)*2'))).interpret();
      return result.value == 11;
    }),

    Test('Arithmetic + sets', () {
      var result = Interpreter(Parser(Lexer('2*3+((1, 2, 3)+4)*2'))).interpret();
      return result.value == 26;
    }),

    Test('Arithmetic + sets + setops', () {
      var result = Interpreter(Parser(Lexer('2*3+((1, 2, 3)kh2+4)*2'))).interpret();
      return result.value == 24;
    }),

    Test('Keeping 3 out of 4 dice.', () {
      var result = Interpreter(Parser(Lexer('4d6kh3'))).interpret();
      var threeRemain = (result as Dice).keptChildren.length == 3;
      var lowestDropped = 
          (result as SetLike).discardedChildren.length == 1 &&
          (result as SetLike).discardedChildren.first.value <= (result as Dice).keptChildren[0].value &&
          (result as SetLike).discardedChildren.first.value <= (result as Dice).keptChildren[1].value &&
          (result as SetLike).discardedChildren.first.value <= (result as Dice).keptChildren[2].value;
      return threeRemain && lowestDropped;
    }, repeats: 100),

    Test('Stat rolling within range of 3 - 18.', () {
      var result = Interpreter(Parser(Lexer('4d6kh3'))).interpret();
      var stat = result.value;
      return makeList(3, 18).contains(stat);
    }, repeats: 10000),

    Test('Keeping 2 out of 3 in a set', () {
      var result = Interpreter(Parser(Lexer('(1, 2+1, 2*2)kh2'))).interpret();
      return listEquality((result as Set).keptChildrenValues, [3,4]);
    }),

    Test('Middle-vantage', () {
      var result = Interpreter(Parser(Lexer('3d20kh2ph1'))).interpret();
      var allThreeValues = (result as SetLike).children.map((c) => c.value).toList();
      allThreeValues.sort();
      return result.value == allThreeValues[1];
    }, repeats: 100),

    Test('Explosions 1', () {
      var result = Interpreter(Parser(Lexer('4d6e>3'))).interpret();
      var die = (result as Dice).die;
      for (var d in die) {
        if (d.value > 3 && !d.exploded) return false;
        if (d.value <= 3 && d.exploded) return false;
      }
      return true;
    }, repeats: 100),

    Test('Explosions 2', () {
      var result = Interpreter(Parser(Lexer('4d6e<3'))).interpret();
      var die = (result as Dice).die;
      for (var d in die) {
        if (d.value < 3 && !d.exploded) return false;
        if (d.value >= 3 && d.exploded) return false;
      }
      return true;
    }, repeats: 100),

    Test('Explosions 3', () {
      var result = Interpreter(Parser(Lexer('4d6e=1e=3e=5'))).interpret();
      var die = (result as Dice).die;
      for (var d in die) {
        if ([1, 3, 5].contains(d.value) && !d.exploded) return false;
        if (![1, 3, 5].contains(d.value) && d.exploded) return false;
      }
      return true;
    }, repeats: 100),

    Test('Die returning', () {
      var result = Interpreter(Parser(Lexer('(3d6, 4d10, 1d20)+2'))).interpret();
      var die = result.die;
      return die.length == 8;
    }, repeats: 100),

  ]);

  tests.performTests();
  tests.printLog();

}