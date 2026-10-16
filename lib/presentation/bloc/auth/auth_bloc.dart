import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/storage/local_storage_service.dart';
import 'package:keyring/core/storage/secure_storage_service.dart';
import 'package:keyring/core/storage/storage_keys.dart';
import 'package:keyring/data/models/auth/sign_in_response_model.dart';
import '../../../core/config/app_config.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final LocalStorageService localStorageService;
  final SecureStorageService secureStorageService;

  AuthBloc({required this.authRepository, required this.localStorageService, required this.secureStorageService}) : super(AuthInitial()) {
    on<SignInRequestEvent>(_onSignIn);
    on<LogoutRequestEvent>(_onLogout);
  }

  Future<void> _onSignIn(SignInRequestEvent event, Emitter<AuthState> emit) async {
    emit(SignInLoading());
    try {
      final SignInResponseModel user = await authRepository.signInUser(username: event.username, password: event.password);
      final UserDataModel data = user.userData!;

      secureStorageService.saveAccessToken(data.accessToken!);
      secureStorageService.saveRefreshToken(data.refreshToken!);
      localStorageService.saveObject(StorageKeys.loggedInAccountData, data.toJson());

      if(data.groupNames!.contains("sub")) {
        localStorageService.saveString(StorageKeys.targetUserId, data.username!);
      }

      emit(SignInSuccess(/*user: user, */ message: signInSuccess));
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutRequestEvent event, Emitter<AuthState> emit) async {
    emit(LogoutLoading());
    try {
      await authRepository.logout();
      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }

}


