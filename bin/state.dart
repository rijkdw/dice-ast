import 'constants.dart' as constants;
import 'error.dart';

var numRollsMade = 0;

void addRollAndCheck() {
  numRollsMade++;
  if (numRollsMade > constants.MAX_ROLLS) {
    raiseError(ErrorType.tooManyRolls);
  }
}