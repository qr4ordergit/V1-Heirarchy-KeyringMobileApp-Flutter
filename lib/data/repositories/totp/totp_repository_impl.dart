import 'package:auth_totp/auth_totp.dart';

import '../../../domain/repositories/totp/totp_repository.dart';

class TotpRepositoryImpl implements TotpRepository {
  @override
  String generateCode({required String secretKey, int interval = 120, int digits = 6}) {
    return AuthTOTP.generateTOTPCode(
      secretKey: secretKey,
      interval: interval,
      digits: digits,
    );
  }
}