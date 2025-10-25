class CommonError {
  final String message;
  final int? code;
  CommonError({required this.message, this.code});
  @override
  String toString() => 'CommonError(code: \$code, message: \$message)';
}
