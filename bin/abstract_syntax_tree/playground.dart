import 'package:petitparser/petitparser.dart';
import 'dart:math' as math;

import '../utils.dart';

void parseWithMultiple() {
  final term = undefined();
  final prod = undefined();
  final prim = undefined();
 
  final add = (prod & char('+').trim() & term).map((values) => values[0] + values[2]);
  term.set(add.or(prod));

  final mul = (prim & char('*').trim() & prod).map((values) => values[0] * values[2]);
  prod.set(mul.or(prim));

  final parens = (char('(').trim() & term & char(')').trim()).map((values) => values[1]);
  final number = digit().plus().flatten().trim().map(int.parse);
  prim.set(parens.or(number));

  final parser = term.end();
  print(parser.parse('(1+3)*2'));
}

void parseWithBuilder() {
  final builder = ExpressionBuilder();

  builder.group()..primitive(digit()
      .plus()
      .seq(char('.').seq(digit().plus()).optional())
      .flatten()
      .trim()
      .map((a) => num.tryParse(a)))
  ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);

  builder.group()..prefix(char('-').trim(), (op, a) => -a);

  builder.group()..right(char('^').trim(), (a, op, b) => math.pow(a,b));

  builder.group()
    ..left(char('*').trim(), (a, op, b) => a*b)
    ..left(char('/').trim(), (a, op, b) => a/b);
  
  builder.group()
    ..left(char('+').trim(), (a, op, b) => a+b)
    ..left(char('-').trim(), (a, op, b) => a-b);

  final parser = builder.build().end();

  print(parser.parse('(1+3)*3'));
}

void parseDiceExpression(String diceExpression) {

  diceExpression = diceExpression.replaceAll(' ', '');

  var builder = ExpressionBuilder();

  // PRIMITIVES
  var numbers = undefined();
  var dice = undefined();
  var sets = undefined();
  var prims = undefined();

  // numbers
  numbers.set(
    digit().plus()
      .seq(char('.').seq(digit().plus()).optional())
      .flatten()
      .trim()
      .map((a) => num.tryParse(a))
  );

  // dice
  dice.set(
    (
      digit().plus().flatten().trim().map(int.parse) 
      & char('d') 
      & digit().plus().flatten().trim().map(int.parse)
    ).map((vals) => Dice.roll(vals.first, vals.last))
  );
  // ).map((vals) => vals.first * vals.last);

  // sets
  // to cater for:
  //    ()
  //    (a, )
  //    (a, b)
  //    (a, b,)
  sets.set(
    (
      // (char('(') & char(')')) |
      (char('(') & (prims & (char(',') & prims).star() & char(',').repeat(0, 1)).repeat(0, 1)) & char(')').flatten()
    )
  );

  prims.set(sets | dice | numbers);
  
  builder.group()..primitive(prims)
    ..wrapper(char('('), char(')'), (l, a, r) => a);

  // PREFIXES
  builder.group()..prefix(char('+'), (op, a) => a);
  builder.group()..prefix(char('-'), (op, a) => -a);

  // SET OPERATIONS
  builder.group()..left((char('k') | char('p')) & (char('h') | char('l')));

  // MULTIPLICATION AND DIVISION
  builder.group()
    ..left(char('*'), (a, op, b) => a*b)
    ..left(char('/'), (a, op, b) => a/b);
  
  // ADDITION AND SUBTRACTION
  builder.group()
    ..left(char('+'), (a, op, b) => a+b)
    ..left(char('-'), (a, op, b) => a-b);
  
  // FINISH AND PARSE
  final parser = builder.build().end();
  var parsedResult = parser.parse(diceExpression);
  print('= ${parsedResult.value}');

  void pprint(dynamic object, int level) {
    if (object is List) {
      for (var item in object) {
        pprint(item, level+1);
      }
    } else {
      print("${' '*level} > $object");
    }
  }

  pprint(parsedResult.value, 0);
}

class SetLike {
  List<num> values;

  SetLike(this.values);

  int get total {
    var sum = 0;
    values.forEach((val) => sum += val);
    return sum;
  }
}

class Dice extends SetLike {
  int number, size;

  Dice(this.number, this.size, List<int> values) : super(values);

  factory Dice.roll(int number, int size) {
    var values = <int>[];
    for (var i = 0; i < number; i++) {
      values.add(randInRange(1, size));
    }
    return Dice(number, size, values);
  }

  @override
  String toString() => 'Dice(number=$number, size=$size, values=$values)';
}

class SetOperation {
  SetLike set;

}

void main() {
  
  // parseWithMultiple();
  // parseWithBuilder();

  var expressions = [
    '1', '10', '(100)', '1d20', '(1d20)', '1+3', '1', '1kh3', '4d6kh3', '4d6kh3kh3',
    '()', '(2)', '(2,)', '(2,3)', '(1d4, 2d6)'
  ];

  print('EXPRESSION TESTS');
  for (var expr in expressions) {
    expr = expr.replaceAll(' ', '');
    print('\nExpression "$expr":');
    parseDiceExpression(expr);
  }

}
