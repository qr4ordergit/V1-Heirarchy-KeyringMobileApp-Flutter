class ApiConstants {
  static const String baseUrl = "https://u2hjtodeyl.execute-api.ap-south-1.amazonaws.com/dev/api";

  // Auth
  static const String signIn = "$baseUrl/auth/mobile-app-login";
  static const String logout = "$baseUrl/auth/logout";
  static const String getNewToken = "$baseUrl/auth/get_new_token";

  // Keyring
  static const String keyring = "$baseUrl/keyring-login-get-catagories";


}