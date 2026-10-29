import '../../../domain/repositories/keyring/keyring_repository.dart';
import '../../../domain/repositories/totp/totp_repository.dart';
import '../../../presentation/cubit/totp/totp_cubit.dart';
import '../../storage/local_storage_service.dart';
import '../../storage/storage_keys.dart';

class NotificationActionHandler {
  NotificationActionHandler({
    required this.keyringRepository,
    required this.localStorageService,
    required this.totpRepository,
  });

  final KeyringRepository keyringRepository;
  final LocalStorageService localStorageService;
  final TotpRepository totpRepository;

  Future<void> handle({
    required String action,
    required Map<String, String> payload,
  }) async {
    if (action != 'ACCEPT' && action != 'REJECT') {
      return;
    }

    final requestId = payload['request_id'];
    final categoryId = payload['keyring_category_id'];

    if (requestId == null ||
        requestId.isEmpty ||
        categoryId == null ||
        categoryId.isEmpty) {
      return;
    }

    final response = await keyringRepository.getKeyringDetails();

    final matchingKeyrings = response.data?.where(
          (item) => item.id == categoryId,
    );

    if (matchingKeyrings == null ||
        matchingKeyrings.isEmpty) {
      throw StateError('Keyring not found: $categoryId');
    }

    final secretKey = matchingKeyrings.first.secretKey;

    if (secretKey == null || secretKey.isEmpty) {
      throw StateError('Keyring secret is unavailable');
    }

    final interval = localStorageService.getInt(StorageKeys.interval);

    final otp = totpRepository.generateCode(
      secretKey: secretKey,
      interval: interval ?? 120,
      digits: TotpCubit.digits,
    );

    await keyringRepository.acceptRejectKeyringRequest(
      data: {
        'request_id': requestId,
        'keyring_category_id': categoryId,
        'action': action == 'ACCEPT' ? 'accepted' : 'rejected',
        'otp': otp,
      },
    );
  }
}