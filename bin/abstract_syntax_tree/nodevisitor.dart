import 'error.dart';
import 'astnode.dart';

class NodeVisitor {
  Map<String, Function> functionMap;

  dynamic visit(AstNode node) {
    var functionName = 'visit${node.runtimeType}';
    var function = functionMap[functionName] ?? genericVisit;
    return function(node);
  }

  void genericVisit(AstNode node) {
    raiseError(ErrorType.noVisitNodeMethod, 'Could not find visit${node.runtimeType}()');
  }
}