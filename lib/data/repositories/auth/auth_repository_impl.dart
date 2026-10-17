import 'dart:developer';
import 'package:keyring/core/services/notifications/notification_service.dart';
import 'package:keyring/core/storage/secure_storage_service.dart';
import 'package:keyring/core/storage/storage_keys.dart';
import 'package:keyring/data/models/auth/sign_in_response_model.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../data_sources/network/api_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;
  final NotificationService notificationService;

  AuthRepositoryImpl({
    required this.apiService,
    required this.localStorageService,
    required this.secureStorageService,
    required this.notificationService,
  });

  @override
  Future<SignInResponseModel> signInUser({required String username, required String password}) async {
    final fcmToken = await notificationService.getDeviceToken();

    if (fcmToken == null) {
      return SignInResponseModel();
    }

    localStorageService.saveString(StorageKeys.fcmToken, fcmToken);

    final response = await apiService.post(
      url: ApiConstants.signIn,
      data: {
        "username": username,
        "password": password,
        "fcm_token": fcmToken,
        "app_id": appId
      },
    );

    final responseModel = SignInResponseModel.fromJson(response.data);
    await secureStorageService.saveAccessToken(responseModel.userData!.accessToken!);
    await secureStorageService.saveRefreshToken(responseModel.userData!.refreshToken!);

    return responseModel;
  }

  @override
  Future<void> logout() async {
    try {
      await apiService.post(url: ApiConstants.logout,
          queryParameters: {
          "redirect_uri": redirectUrl
          },
          data: {
            "fcm_token": localStorageService.getString(StorageKeys.fcmToken),
            "app_id": appId
          }
      );
    } finally {
      await Future.wait([
        localStorageService.clearAll(),
        secureStorageService.deleteTokens(),
      ]);
    }
  }
}
