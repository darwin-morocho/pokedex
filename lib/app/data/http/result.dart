abstract class HttpResult<T> {
  final int? statusCode;

  HttpResult(this.statusCode);
}

class HttpSuccess<T> extends HttpResult<T> {
  HttpSuccess(super.statusCode, this.data);
  final T data;
}

class HttpFailure<T> extends HttpResult<T> {
  HttpFailure(
    super.statusCode, {
    this.data,
    this.exception,
    this.stackTrace,
  });
  final Object? exception;
  final StackTrace? stackTrace;
  final Object? data;
}
