abstract class TotpRepository {
  String generateCode({
    required String secretKey,
    int interval = 30,
    int digits = 6,
  });

  // void updateOtp({
  //   required String keyringCategoryId,
  //   required String otp,
  // });
  //
  // String? getOtp(String keyringCategoryId);
  //
  // void removeOtp(String keyringCategoryId);
  //
  // void clear();
}