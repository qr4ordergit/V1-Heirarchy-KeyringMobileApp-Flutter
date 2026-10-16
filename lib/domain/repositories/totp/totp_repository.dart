abstract class TotpRepository {
  String generateCode({required String secretKey, int interval = 120, int digits = 6});
}