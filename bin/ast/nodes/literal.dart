import '../objects/token.dart';
import 'node.dart';

class Literal extends Node {
  
  // attributes
  
  Token token;
  num literalValue;

  // constructor

  Literal(this.token) {
    literalValue = token.value;
  }

  // override Node methods

  @override
  int get value => literalValue;

  // override Object methods

  @override
  String toString() {
    return 'Literal(value=$value)';
  }
}