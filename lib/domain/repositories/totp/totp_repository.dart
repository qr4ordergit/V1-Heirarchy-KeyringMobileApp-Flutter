abstract class TotpRepository {
  String generateCode({required String secretKey, int interval = 30, int digits = 6});
}