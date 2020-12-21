import 'package:petitparser/petitparser.dart';

void main() {
  final id = letter() & (letter() | digit()).star();
  print(id.parse('yeah').value);
}
