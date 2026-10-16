import 'package:keyring/core/storage/local_storage_service.dart';
import 'package:keyring/core/storage/storage_keys.dart';

import '../../../core/constants/api_constants.dart';
import '../../../domain/repositories/keyring/keyring_repository.dart';
import '../../data_sources/network/api_service.dart';
import '../../models/keyring/keyring_model.dart';

class KeyringRepositoryImpl extends KeyringRepository {
  final ApiService apiService;
  KeyringRepositoryImpl({required this.apiService});

  @override
  Future<KeyringModel> getKeyringDetails() async {
    final response = await apiService.get(
      url: ApiConstants.keyring,
    );

    return KeyringModel.fromJson(response.data);
  }

  @override
  Future<dynamic> getKeyringPassword({required String keyringCategoryId, required String otp}) async {

    final response = await apiService.get(
      url: ApiConstants.keyring,
      queryParameters: {
        'keyring_category_id': keyringCategoryId,
        'otp': otp,
      },
    );

    return response.data;
  }

  @override
  Future<dynamic> acceptRejectKeyringRequest({
    required Map<String, dynamic> data,
  }) async {

    final response = await apiService.post(
      url: ApiConstants.keyringRequestHandler,
      data: data,
    );

    return response.data;
  }


}