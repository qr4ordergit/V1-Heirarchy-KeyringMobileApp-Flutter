import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/storage/local_storage_service.dart';
import 'package:keyring/core/storage/secure_storage_service.dart';
import 'package:keyring/domain/repositories/auth/auth_repository.dart';
import '../../domain/repositories/keyring/keyring_repository.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/keyring/keyring_bloc.dart';

List<BlocProvider> get blocProviders => [
  // BlocProvider<InternetCubit>(create: (_) => InternetCubit()),
  //
  // BlocProvider<ThemeCubit>(
  //   create: (context) => ThemeCubit(
  //     localStorageService: context.read<LocalStorageService>(),
  //   ),
  // ),

  BlocProvider<AuthBloc>(
    create: (context) => AuthBloc(
      authRepository: context.read<AuthRepository>(),
      localStorageService: context.read<LocalStorageService>(),
      secureStorageService: context.read<SecureStorageService>(),
    ),
  ),

  BlocProvider<KeyringBloc>(
    create: (context) => KeyringBloc(
        keyringRepository: context.read<KeyringRepository>()
    ),)
];