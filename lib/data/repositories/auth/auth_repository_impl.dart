import 'dart:developer';
import 'package:keyring/core/services/notifications/notification_service.dart';
import 'package:keyring/core/storage/secure_storage_service.dart';
import 'package:keyring/core/storage/storage_keys.dart';
import 'package:keyring/data/models/auth/sign_in_response_model.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/api_exceptions.dart';
import '../../../core/services/device/device_info_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../data_sources/network/api_service.dart';
import '../../models/devices/device_model.dart';

class AuthRepositoryImpl extends AuthRepository {
  final ApiService apiService;
  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl({
    required this.apiService,
    required this.localStorageService,
    required this.secureStorageService,
  });

  @override
  Future<SignInResponseModel> signInUser({required String username, required String password}) async {
    final fcmToken = await NotificationService.getDeviceToken();

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
        "app_id": appId,
      },
    );

    final responseModel = SignInResponseModel.fromJson(response.data);
    await secureStorageService.saveAccessToken(responseModel.userData!.accessToken!);
    await secureStorageService.saveRefreshToken(responseModel.userData!.refreshToken!);

    return responseModel;
  }

  @override
  Future<dynamic> logoutSpecificUser({required String sessionId}) async {
    final response  = await apiService.post(url: ApiConstants.userSession,
        data: {
          "session_id": sessionId,
        }
    );
    return response.data;
  }


  @override
  Future<void> logout({bool isAllDevice = false}) async {
    try {
      await apiService.post(url: ApiConstants.logout,
          data: {
            "fcm_token": localStorageService.getString(StorageKeys.fcmToken),
            if (!isAllDevice)
              "refresh_token": localStorageService.getString(StorageKeys.refreshToken),
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


  @override
  Future<DeviceModel> registerDevice() async {
    try {
      final deviceName = await DeviceInfoService.getDeviceName();
      final platform = await DeviceInfoService.getPlatform();
      final browser = await DeviceInfoService.getBrowserName();
      final isApp = DeviceInfoService.isApp();

      final response = await apiService.post(
          url: ApiConstants.userSession,
          data: {
            "refresh_token": localStorageService.getString(StorageKeys.refreshToken),
            "app_id": appId,
            "Content-Type": "application/json",
            "platform": platform,
            "browser": browser,
            "app": isApp,
            "device_name": deviceName,
          }
      );
      return DeviceModel.fromJson(response.data);
      // return response.data;
    } on ForbiddenException catch (e) {
      final data = e.data;
      if (data is Map && data['Device_List'] != null && data["success"] == false) {
        return DeviceModel.fromJson(e.data);
      }
      rethrow; // a normal 403 unrelated to device limit
    }
  }
  @override
  Future<DeviceModel> getDevices() async {
    try {
      final response = await apiService.post(url: ApiConstants.userSession);
      return DeviceModel.fromJson(response.data);
    } on ForbiddenException catch (e) {
      final data = e.data;
      if (data is Map && data['Device_List'] != null && data["success"] == false) {
        return DeviceModel.fromJson(e.data);
      }
      rethrow; // a normal 403 unrelated to device limit
    }
  }

}
