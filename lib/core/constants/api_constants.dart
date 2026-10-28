class ApiConstants {
  static const String baseUrl = "https://53mxdgl1ok.execute-api.eu-central-1.amazonaws.com/dev/api";
  // static const String baseUrl = "https://u2hjtodeyl.execute-api.ap-south-1.amazonaws.com/dev/api";

  // Auth
  static const String signIn = "$baseUrl/auth/mobile-app-login";
  static const String logout = "$baseUrl/auth/logout";
  static const String getNewToken = "$baseUrl/auth/get_new_token";

  // Keyring
  static const String keyring = "$baseUrl/keyring-login-get-catagories";
  static const String keyringRequestHandler = "$baseUrl/2fa-action";
  static const String interval = "$baseUrl/keyring-categories/second";


}