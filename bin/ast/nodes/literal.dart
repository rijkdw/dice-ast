import '../objects/token.dart';
import 'node.dart';

class Literal extends Node {
  Token token;
  num literalValue;

  Literal(this.token) {
    literalValue = token.value;
  }
}