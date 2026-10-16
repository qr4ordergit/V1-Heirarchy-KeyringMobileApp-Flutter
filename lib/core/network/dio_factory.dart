import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/local_storage_service.dart';
import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'dio_logger_interceptor.dart';


class DioFactory {
  DioFactory._();

  static Dio create({
    required LocalStorageService localStorageService,
    required SecureStorageService secureStorageService,
  }) {
    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    );

    // Main API client
    final dio = Dio(options);

    // Separate client for token refresh.
    // Do not attach AuthInterceptor to this instance.
    final refreshDio = Dio(options);

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        refreshDio: refreshDio,
        localStorageService: localStorageService,
        secureStorageService: secureStorageService,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        DioLoggerInterceptor(),
      );
    }

    // if (kDebugMode) {
    //   dio.interceptors.add(
    //     LogInterceptor(
    //       request: true,
    //       requestHeader: true,
    //       requestBody: true,
    //       responseHeader: true,
    //       responseBody: true,
    //       error: true,
    //       logPrint: (object) => debugPrint(object.toString()),
    //     ),
    //   );
    //
    //   refreshDio.interceptors.add(
    //     LogInterceptor(
    //       request: true,
    //       requestHeader: true,
    //       requestBody: true,
    //       responseHeader: true,
    //       responseBody: true,
    //       error: true,
    //       logPrint: (object) => debugPrint(object.toString()),
    //     ),
    //   );
    // }

    return dio;
  }

  /// No interceptors — safe for presigned URLs (S3, GCS, etc.)
  /// where auth is already embedded in the URL/query params.
  // static Dio createPlain() {
  //   final dio = Dio(
  //     BaseOptions(
  //       connectTimeout: const Duration(seconds: 60),
  //       sendTimeout: const Duration(minutes: 5), // uploads can be slow
  //       receiveTimeout: const Duration(seconds: 60),
  //     ),
  //   );
  //
  //   if (kDebugMode) {
  //     dio.interceptors.add(
  //       DioLoggerInterceptor(),
  //     );
  //   }
  //
  //   return dio;
  // }
  //
  // /// No auth, no interceptors except logging.
  // /// Use for public endpoints (language files, app config, etc.)
  // static Dio createPublic() {
  //   final dio = Dio(
  //     BaseOptions(
  //       connectTimeout: const Duration(seconds: 30),
  //       receiveTimeout: const Duration(seconds: 30),
  //       sendTimeout: const Duration(seconds: 30),
  //     ),
  //   );
  //
  //   if (kDebugMode) {
  //     dio.interceptors.add(DioLoggerInterceptor());
  //   }
  //
  //   return dio;
  // }
}