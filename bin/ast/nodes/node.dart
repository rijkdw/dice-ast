import '../objects/die.dart';
import '../../error.dart';

class Node {

  // ignore: missing_return
  String visualise() {
    raiseError(ErrorType.notImplemented);
  }

  /// Return the integer value of this node.
  int get value => 0;

  // for a binary node, this would = A OP B
  // for a unary node, this would = OP A
  // for a dice node, this would be the sum of the results of its rolls
  // for a literal node, this would be its value

  /// The list of Die objects this node has
  List<Die> get die => [];
}
