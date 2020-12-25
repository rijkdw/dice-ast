import 'abstract_syntax_tree/roller.dart';

void main() {
  var result = Roller.roll('1d6n=3');
  print(result);
  print(result.total);
}