import '../objects/setop.dart';
import '../objects/token.dart';
import 'node.dart';
import 'setlike.dart';

class Set extends SetLike {
  Token token;
  List<Node> children;

  Set(this.token, this.children);

}