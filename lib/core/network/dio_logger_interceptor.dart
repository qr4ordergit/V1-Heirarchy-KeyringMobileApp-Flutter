import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
class DioLoggerInterceptor extends Interceptor {

  String _toJsonString(dynamic data) {
    try {
      if (data == null) {
        return 'null';
      }

      // Don't print binary data such as file upload bytes (Upload Files Bytes).
      if (data is List<int>) {
        return '<binary data: ${data.length} bytes>';
      }

      if (data is String) {
        try {
          // If it's already a JSON string, validate it
          jsonDecode(data);
          return data;
        } catch (_) {
          // If not valid JSON, convert to JSON string
          return jsonEncode(data);
        }
      }

      return jsonEncode(data);
    } catch (_) {
      return data.toString();
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('┌─ REQUEST ─────────────────────────');
    log('${options.method} ${options.uri}');

    if (options.headers.isNotEmpty) {
      log('Headers:');
      options.headers.forEach((key, value) {
        log('  $key: $value');
      });
    }

    if (options.data != null) {
      log('Body:');
      log(_toJsonString(options.data));
    }

    log('└──────────────────────────────────');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('┌─ RESPONSE ────────────────────────');
      // log('Headers:');
      // response.headers.forEach((key, value) {
      //   log('  $key: $value');
      // });


    log(
      '${response.statusCode} '
          '${response.requestOptions.method} '
          '${response.requestOptions.uri}',
    );

    if (response.data != null) {
      log('Body:');
      log(_toJsonString(response.data));
    }

    log('└──────────────────────────────────');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('┌─ ERROR ───────────────────────────');
    log(
      '${err.response?.statusCode ?? 'N/A'} '
          '${err.requestOptions.method} '
          '${err.requestOptions.uri}',
    );
    log('Message: ${err.message}');

    if (err.requestOptions.headers.isNotEmpty) {
      log('Request Headers:');
      err.requestOptions.headers.forEach((key, value) {
        log('  $key: $value');
      });
    }

    if (err.response?.data != null) {
      log('Response Body:');
      log(_toJsonString(err.response?.data));
    }

    log('└──────────────────────────────────');
    handler.next(err);
  }
}
