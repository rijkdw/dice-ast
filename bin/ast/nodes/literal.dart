import '../objects/token.dart';
import 'die.dart';
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

  @override
  String visualise() => '$literalValue';

  @override
  List<Die> get die => [];

  // override Object methods

  @override
  String toString() {
    return 'Literal(value=$value)';
  }
}