import 'dart:io';

import '../../domain/either/either.dart';
import '../../domain/failures/http_request/http_request_failure.dart';
import '../http/result.dart';

Future<Either<HttpRequestFailure, R>> performHttpRequest<R>(
  Future<HttpResult<R>> future,
) async {
  final result = await future;
  if (result is HttpSuccess<R>) {
    return Either.right(result.data);
  }
  return Either.left(
    handleHttpFailure(result as HttpFailure<R>),
  );
}

HttpRequestFailure handleHttpFailure<R>(HttpFailure<R> result) {
  final statusCode = result.statusCode;
  if (statusCode != null) {
    if (statusCode == 404) {
      return HttpRequestFailure.notFound();
    }
    if (statusCode == 401 || statusCode == 403) {
      return HttpRequestFailure.unauthorized();
    } else if (statusCode == 406 || statusCode == 400) {
      return HttpRequestFailure.badRequest();
    } else if (statusCode >= 500) {
      return HttpRequestFailure.server();
    }
  }

  final exception = result.exception;
  if (exception is SocketException) {
    return HttpRequestFailure.network();
  }
  return HttpRequestFailure.unhandled();
}
