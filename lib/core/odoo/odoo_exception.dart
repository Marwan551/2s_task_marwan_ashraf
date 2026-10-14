class OdooException implements Exception {
  final String message;
  final int? code;
  final dynamic data;
  final bool isNetworkError;

  OdooException(
    this.message, {
    this.code,
    this.data,
    this.isNetworkError = false,
  });

  @override
  String toString() => 'OdooException: $message (code: $code)';
}

String userFacingOdooError(Object error) {
  if (error is OdooException) return error.message;
  return error.toString().replaceFirst('Exception: ', '');
}
