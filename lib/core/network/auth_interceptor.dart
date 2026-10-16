import 'package:dio/dio.dart';
import 'package:keyring/core/storage/local_storage_service.dart';
import '../../main.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';
import '../routes/app_routes.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final Dio refreshDio;
  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;

  AuthInterceptor({
    required this.dio,
    required this.refreshDio,
    required this.localStorageService,
    required this.secureStorageService,
  });

  bool _isAuthRequest(String path) {
    return path.contains(ApiConstants.signIn) || path.contains(ApiConstants.getNewToken);
  }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (!_isAuthRequest(options.path)) {
        final token = await secureStorageService.getAccessToken();

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
        ),
      );
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 || _isAuthRequest(request.path) || request.extra['retried'] == true) {
      handler.next(err);
      return;
    }

    try {
      final refreshToken = await secureStorageService.getRefreshToken();
      final accessToken = await secureStorageService.getAccessToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await _handleSessionExpired();
        handler.next(err);
        return;
      }

// Separate Dio instance: refresh must not recursively
// trigger this interceptor.
      final response = await refreshDio.post(
        ApiConstants.getNewToken,
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken'
          }
        ),
        data: {
          'refresh_token': refreshToken,
        },
      );

      final data = response.data as Map<String, dynamic>;

      final newAccessToken = data['access_token'] as String;
      // final newRefreshToken = (data['refresh_token'] as String?) ?? refreshToken;

      await secureStorageService.saveAccessToken(
         newAccessToken,
      );

      request.headers['Authorization'] = 'Bearer $newAccessToken';
      request.extra['retried'] = true;

      final retryResponse = await dio.fetch(request);

      handler.resolve(retryResponse);
    } catch (_) {
      await _handleSessionExpired();
      handler.next(err);
    }
  }

  Future<void> _handleSessionExpired() async {
    await localStorageService.clearAll();
    await secureStorageService.deleteTokens();

    final navigator = appNavigatorKey.currentState;

    if (navigator != null) {
      navigator.pushNamedAndRemoveUntil(
        AppRoutes.signIn,
            (route) => false,
      );
    }
  }
}
