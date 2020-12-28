import 'die.dart';
import '../../error.dart';

abstract class Node {

  // attributes

  bool _kept = true;

  // getters

  bool get isKept => _kept;
  bool get isDiscarded => !_kept;

  // setters

  void discard() => _kept = false;

  /// Return this node in dice notation.
  String visualise();

  /// Return the integer value of this node.
  int get value;

  // for a binary node, this would = A OP B
  // for a unary node, this would = OP A
  // for a dice node, this would be the sum of the results of its rolls
  // for a literal node, this would be its value

  /// The list of Die objects this node has.
  List<Die> get die;
}
