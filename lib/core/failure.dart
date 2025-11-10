class Failure implements Exception {
  final String message;
  final int? statusCode;
  final Object? cause;

  const Failure(this.message, {this.statusCode, this.cause});

  @override
  String toString() =>
      'Failure(message: $message, statusCode: $statusCode, cause: $cause)';
}
