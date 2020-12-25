import 'abstract_syntax_tree/roller.dart';

void main() {
  var result = Roller.roll('4d6k>3');
  print(result);
  print(result.total);
}