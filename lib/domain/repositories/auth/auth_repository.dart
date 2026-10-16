import 'package:keyring/data/models/auth/sign_in_response_model.dart';

abstract class AuthRepository {
  Future<SignInResponseModel> signInUser({required String username, required String password});
  Future<void> logout();
}
