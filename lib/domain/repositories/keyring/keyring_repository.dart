
import '../../../data/models/keyring/keyring_model.dart';

abstract class KeyringRepository {

  Future<KeyringModel> getKeyringDetails();

  Future<dynamic> getKeyringPassword({required String keyringCategoryId, required String otp});

  Future<dynamic> acceptRejectKeyringRequest({required Map<String, dynamic> data});

  Future<dynamic> getInterval();

  Future<dynamic> updateInterval({required Map<String, dynamic> data});


}