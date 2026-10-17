import 'package:auth_totp/auth_totp.dart';

import '../../../domain/repositories/totp/totp_repository.dart';

class TotpRepositoryImpl implements TotpRepository {
  // final Map<String, String> _otps = {};

  @override
  String generateCode({
    required String secretKey,
    int interval = 30,
    int digits = 6,
  }) {
    return AuthTOTP.generateTOTPCode(
      secretKey: secretKey,
      interval: interval,
      digits: digits,
    );
  }

  // @override
  // void updateOtp({
  //   required String keyringCategoryId,
  //   required String otp,
  // }) {
  //   if (otp.isEmpty) {
  //     _otps.remove(keyringCategoryId);
  //     return;
  //   }
  //
  //   _otps[keyringCategoryId] = otp;
  // }
  //
  // @override
  // String? getOtp(String keyringCategoryId) {
  //   return _otps[keyringCategoryId];
  // }
  //
  // @override
  // void removeOtp(String keyringCategoryId) {
  //   _otps.remove(keyringCategoryId);
  // }
  //
  // @override
  // void clear() {
  //   _otps.clear();
  // }
}