enum ErrorType {
  invalidSyntax,
  unexpectedEndOfFunction,
  eatError,
}

String errorToString(ErrorType errorType) {
  return <ErrorType, String>{
    ErrorType.invalidSyntax: 'Invalid syntax',
    ErrorType.unexpectedEndOfFunction: 'Unexpected end of function',
    ErrorType.eatError: 'Eat error'
  }[errorType];
}

void raiseError(ErrorType errorType, [String additional]) {
  throw Exception('Error -- ${errorToString(errorType)} ($additional)');
}
