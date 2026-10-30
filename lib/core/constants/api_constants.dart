class ApiConstants {
  // static const String domain = "https://u2hjtodeyl.execute-api.ap-south-1.amazonaws.com";
  static const String domain = "https://53mxdgl1ok.execute-api.eu-central-1.amazonaws.com";
  static const String basePath = "/dev/api";
  static const String baseUrl = "$domain$basePath";


  // Auth
  static const String signIn = "$baseUrl/auth/mobile-app-login";
  static const String logout = "$baseUrl/auth/logout";
  static const String getNewToken = "$baseUrl/auth/get_new_token";
  static const String userSession = "$baseUrl/auth/user-session";


  // Keyring
  static const String keyring = "$baseUrl/keyring-login-get-catagories";
  static const String keyringRequestHandler = "$baseUrl/2fa-action";
  static const String interval = "$baseUrl/keyring-categories/second";


}