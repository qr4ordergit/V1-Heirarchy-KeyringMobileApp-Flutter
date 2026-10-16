class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException({
    this.message = 'Something went wrong. Please try again.',
    this.statusCode,
  });

  @override
  String toString() => message;
}

/// 400 — malformed request
class BadRequestException extends ApiException {
  const BadRequestException({super.message, super.statusCode = 400});
}

/// 401 — unauthenticated
class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message, super.statusCode = 401});
}

/// 403 — forbidden
class ForbiddenException extends ApiException {
  const ForbiddenException({super.message, super.statusCode = 403});
}

/// 404 — not found
class NotFoundException extends ApiException {
  const NotFoundException({super.message, super.statusCode = 404});
}

/// 409 — conflict (e.g. duplicate entry)
class ConflictException extends ApiException {
  const ConflictException({super.message, super.statusCode = 409});
}

/// 422 — validation errors with field-level detail
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    super.message,
    super.statusCode = 422,
    this.errors,
  });

  @override
  String toString() => 'ValidationException($statusCode): $message | errors: $errors';
}

/// 429 — rate limit hit
class RateLimitException extends ApiException {
  const RateLimitException({super.message, super.statusCode = 429});
}

/// 5xx — server-side failure
class ServerException extends ApiException {
  const ServerException({super.message, super.statusCode});
}

/// Timeout (connection / send / receive / 408)
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Connection timed out. Please try again.',
  }) : super(statusCode: 408);
}

/// No internet / socket error
class NoInternetException extends ApiException {
  const NoInternetException({
    super.message = 'No internet connection.',
  }) : super(statusCode: null);
}

/// Request cancelled
class CancelledException extends ApiException {
  const CancelledException({
    super.message = 'Request was cancelled.',
  }) : super(statusCode: null);
}