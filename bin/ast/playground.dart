import 'package:petitparser/petitparser.dart';
import 'dart:math' as math;

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

  var builder = ExpressionBuilder();

  // numbers
  builder.group()
    ..primitive(
      digit().plus()
        .seq(char('.').seq(digit().plus()).optional())
        .flatten().trim().map((a) => num.tryParse(a)))
    ..wrapper(char('(').trim(), char(')').trim(), (l, a, r) => a);

  builder.group()..primitive(
    digit().plus().flatten()
    & char('d')
    & digit().plus()
    .flatten().trim());
    
  final parser = builder.build().end();

  print(parser.parse(diceExpression));
}

void main() {
  
  parseWithMultiple();
  parseWithBuilder();
  parseDiceExpression('1d20');

}
