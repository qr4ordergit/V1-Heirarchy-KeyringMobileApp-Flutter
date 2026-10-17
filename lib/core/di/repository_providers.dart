import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/navigation/navigation_handler.dart';
import 'package:keyring/core/network/dio_factory.dart';
import 'package:keyring/core/services/notifications/notification_service.dart';
import 'package:keyring/core/storage/secure_storage_service.dart';
import 'package:keyring/data/repositories/keyring/keyring_repository_impl.dart';
import 'package:keyring/data/repositories/totp/totp_repository_impl.dart';
import 'package:keyring/domain/repositories/keyring/keyring_repository.dart';
import 'package:keyring/domain/repositories/totp/totp_repository.dart';
import '../../data/data_sources/network/api_service.dart';
import '../../data/repositories/auth/auth_repository_impl.dart';
import '../../domain/repositories/auth/auth_repository.dart';
import '../storage/local_storage_service.dart';

List<RepositoryProvider> repositoryProviders({
  required LocalStorageService localStorageService,
  required SecureStorageService secureStorageService,
}) => [

  RepositoryProvider<LocalStorageService>(
    create: (_) => localStorageService,
  ),

  RepositoryProvider<SecureStorageService>(
    create: (_) => secureStorageService,
  ),

  // One NotificationService instance
  RepositoryProvider<NotificationService>(
    create: (_) => NotificationService(),
  ),

  RepositoryProvider<ActiveKeyringTracker>(create: (_) => ActiveKeyringTracker()),

  RepositoryProvider<Dio>(
    create: (context) => DioFactory.create(
      localStorageService: context.read<LocalStorageService>(),
      secureStorageService: context.read<SecureStorageService>(),
    )
  ),

  RepositoryProvider<ApiService>(
    create: (context) => ApiService(
      dio: context.read<Dio>(),
    ),
  ),


  RepositoryProvider<TotpRepository>(
    create: (_) => TotpRepositoryImpl(),
  ),

  RepositoryProvider<KeyringRepository>(
    create: (context) => KeyringRepositoryImpl(
        apiService: context.read<ApiService>(),
    ),
  ),


  RepositoryProvider<AuthRepository>(
    create: (context) => AuthRepositoryImpl(
      apiService: context.read<ApiService>(),
      localStorageService: context.read<LocalStorageService>(),
      secureStorageService: context.read<SecureStorageService>(),
      notificationService: context.read<NotificationService>(),
    ),
  ),

];

