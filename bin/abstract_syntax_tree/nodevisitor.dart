import '../error.dart';
import 'ast_node.dart';

class NodeVisitor {
  Map<String, Function> functionMap;
  AstNode previouslyVisitedNode;

  void visit(AstNode node) {
    var functionName = 'visit${node.runtimeType}';
    var function = functionMap[functionName] ?? genericVisit;
    function(node);
  }

  void genericVisit(AstNode node) {
    raiseError(ErrorType.noVisitNodeMethod, 'Could not find visit${node.runtimeType}()');
  }
}