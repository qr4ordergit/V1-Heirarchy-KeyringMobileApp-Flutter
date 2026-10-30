import 'package:keyring/data/models/auth/sign_in_response_model.dart';

import '../../../data/models/devices/device_model.dart';

abstract class AuthRepository {
  Future<SignInResponseModel> signInUser({required String username, required String password});
  Future<dynamic> logoutSpecificUser({required String sessionId});
  Future<void> logout({bool isAllDevice = false});

  Future<DeviceModel> registerDevice();
  Future<DeviceModel> getDevices();
}

