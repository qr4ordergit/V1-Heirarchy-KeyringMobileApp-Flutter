
import '../../../data/models/keyring/keyring_model.dart';

abstract class KeyringRepository {

  Future<KeyringModel> getKeyringDetails();

  Future<dynamic> getKeyringPassword({required String keyringCategoryId, required String otp});


}