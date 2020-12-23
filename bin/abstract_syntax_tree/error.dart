enum ErrorType {
  invalidSyntax,
  unexpectedEndOfFunction,
  eatError,
  noVisitNodeMethod,
  notImplemented,
}

String errorToString(ErrorType errorType) {
  return <ErrorType, String>{
    ErrorType.invalidSyntax: 'Invalid syntax',
    ErrorType.unexpectedEndOfFunction: 'Unexpected end of function',
    ErrorType.eatError: 'Eat error',
    ErrorType.noVisitNodeMethod: 'No \"visit node\" method',
    ErrorType.notImplemented: 'Method not implemented'
  }[errorType];
}

void raiseError(ErrorType errorType, [String additional]) {
  throw Exception('Error -- ${errorToString(errorType)} ($additional)');
}
