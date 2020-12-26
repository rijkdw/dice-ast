import '../../error.dart';
import '../nodes/node.dart';

class NodeVisitor {
  Map<String, Function> functionMap;
  Node previouslyVisitedNode;

  void visit(Node node) {
    var functionName = 'visit${node.runtimeType}';
    var function = functionMap[functionName] ?? genericVisit;
    function(node);
  }

  void genericVisit(Node node) {
    raiseError(ErrorType.noVisitNodeMethod, 'Could not find visit${node.runtimeType}()');
  }
}