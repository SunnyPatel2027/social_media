import '../models/common_error.dart';
import 'app_exceptions.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is AuthException) return Failure(error.message);
    if (error is ServerException) return Failure(error.message);
    if (error is Exception) return Failure(error.toString());
    return const Failure('Unknown error');
  }

  static CommonError toCommonError(dynamic error) {
    if (error is AuthException) return CommonError(message: error.message);
    if (error is ServerException) return CommonError(message: error.message);
    if (error is Exception) return CommonError(message: error.toString());
    return CommonError(message: 'Unknown error');
  }
}
