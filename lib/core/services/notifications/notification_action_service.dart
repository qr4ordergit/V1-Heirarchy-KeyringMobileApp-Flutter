import '../../../data/data_sources/network/api_service.dart';
import '../../../data/repositories/keyring/keyring_repository_impl.dart';
import '../../../data/repositories/totp/totp_repository_impl.dart';
import '../../network/dio_factory.dart';
import '../../storage/local_storage_service.dart';
import '../../storage/secure_storage_service.dart';
import 'notification_action_handler.dart';

class NotificationActionService {
  static Future<NotificationActionHandler> create() async {
    // Initialize the storage services using your actual constructors.
    final localStorageService = await LocalStorageService.getInstance();
    final secureStorageService = SecureStorageService.instance;

    final dio = DioFactory.create(
      localStorageService: localStorageService,
      secureStorageService: secureStorageService,
    );

    final apiService = ApiService(dio: dio);

    final keyringRepository = KeyringRepositoryImpl(
      apiService: apiService,
    );

    final totpRepository = TotpRepositoryImpl();

    return NotificationActionHandler(
      keyringRepository: keyringRepository,
      localStorageService: localStorageService,
      totpRepository: totpRepository,
    );
  }
}