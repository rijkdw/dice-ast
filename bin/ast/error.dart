enum ErrorType {
  invalidSyntax,
}

String errorToString(ErrorType errorType) {
  return <ErrorType, String>{
    ErrorType.invalidSyntax: 'Invalid syntax',
  }[errorType];
}

void raiseError({ErrorType errorType}) {
  throw Exception('Error -- ${errorToString(errorType)}');
}
