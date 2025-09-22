class ApiException implements Exception {
  final bool status;
  final String message;

  ApiException(this.status, this.message);

  @override
  String toString() {
    return 'ApiException: Status code: $status, Message: $message';
  }
}
