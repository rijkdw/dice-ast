import 'error.dart';
import 'node.dart';

class NodeVisitor {
  Map<String, Function> functionMap;

  dynamic visit(Node node) {
    var functionName = 'visit${node.runtimeType}';
    var function = functionMap[functionName] ?? genericVisit;
    return function(node);
  }

  void genericVisit(Node node) {
    raiseError(ErrorType.noVisitNodeMethod, 'Could not find visit${node.runtimeType}()');
  }
}