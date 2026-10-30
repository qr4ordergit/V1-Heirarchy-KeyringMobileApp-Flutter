import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/errors/api_exceptions.dart';

class ApiService {
  final Dio dio;        // authenticated: normal API calls

  ApiService({
    required this.dio,
  });

  Future<Response> get({ required String url, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(url, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> post({required String url, dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.post(url, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> patch({required String url, dynamic data}) async {
    try {
      return await dio.patch(url, data: data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> put({required String url, dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.put(url, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Future<Response> delete({required String url, dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.delete(url, data: data, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }



  // ---------- Centralized error mapping ----------

  ApiException _handleDioException(DioException error) {

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();

      case DioExceptionType.badResponse:
        return _mapBadResponse(error);
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled.');

      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection.');

      default:
        return ApiException(message: 'Unexpected error occurred.');
    }
  }

  ApiException _mapBadResponse(DioException error) {
    final int? statusCode = error.response?.statusCode;
    final dynamic data = error.response?.data;

    final String message = (data is Map && (data['error'] ?? data['message']) != null)
        ? (data['error'] ?? data['message']).toString()
        : 'Something went wrong. Please try again.';

    switch (statusCode) {
      case 400:
        return BadRequestException(message: message);
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message, data: data);
      case 404:
        return NotFoundException(message: message, data: data);
      case 409:
        return ConflictException(message: message);
      case 422:
        final errors = (data is Map && data['errors'] is Map)
            ? Map<String, dynamic>.from(data['errors'])
            : null;
        return ValidationException(message: message, errors: errors);
      case 429:
        return RateLimitException(message: message);
      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(message: message, statusCode: statusCode);
        }
        return ApiException(message: message, statusCode: statusCode);
    }
  }

}