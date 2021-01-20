import '../../utils.dart';
import '../objects/token.dart';
import 'die.dart';
import 'node.dart';
import 'setlike.dart';

class Set extends SetLike {

  // attributes

  Token token;

  // constructor

  Set(this.token, List<Node> children) {
    this.children = children;
  }
  
  // override Node methods

  @override
  String visualise() => '(' + join(children.map((c) => c.visualise()).toList(), ', ') + ')';

  @override
  String breakdown([int level=0]) {
    var returnVal = 'A set containing';
    for (var i = 0; i < children.length; i++) {
      returnVal += '\n${tabs(level+1)}${i+1}: ${children[i].breakdown(level+1)}';
    }
    if (setOps.length == 1) {
      returnVal += '\n${tabs(level+1)}with setop ${setOps.first.breakdown()}';
    } else if (setOps.isNotEmpty) {
      returnVal += '\nwith setops';
      returnVal += setOpsToString(level+1);
    }    
    returnVal += '\nwith a total of <b>$value</b>';
    return returnVal;
  }

  @override
  Node get copy {
    var returnSet = Set(null, children.map((c) => c).toList());
    returnSet.setOps.addAll(setOps);
    return returnSet;
  }

  @override
  List<Die> get die {
    // return List<Die>.from(joinLists(children.map((child) => child.die).toList()));
    var returnList = <Die>[];
    for (var child in children) {
      var childDie = child.die;
      if (child.isDiscarded) {
        childDie.forEach((cd) => cd.discard());
      }
      returnList.addAll(childDie);
    }
    return returnList;
  }

  // @override
  // List<Die> get die => List<Die>.from(joinLists(children.map((child) => child.die).toList()));

  // override Object methods

  @override
  String toString() => 'Set(children=$children, setOps=$setOps)';

}