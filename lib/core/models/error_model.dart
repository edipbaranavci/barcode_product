import 'dart:developer';

class ErrorModel {
  final String errorMessage;
  ErrorModel(this.errorMessage);

  @override
  String toString() => 'ErrorModel! => (errorMessage: $errorMessage)';

  void printError() => log('${'*' * 10}\n${toString()}\n${'*' * 10}');
}
