import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyring/core/storage/storage_keys.dart';
import '../../../core/config/app_config.dart';
import '../../../core/enums/enums.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../data/models/devices/device_model.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import 'device_event.dart';
import 'device_state.dart';


class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final AuthRepository authRepository;
  final LocalStorageService localStorageService;

  DeviceBloc({
    required this.authRepository,
    required this.localStorageService,
  }) : super(DeviceState()) {
    on<InitDevicesEvent>(_onInitDevices);
    on<RegisterDevicesEvent>(_onRegisterDevice);
    on<GetDevicesEvent>(_onGetDevices);
    on<LogoutSpecificDeviceEvent>(_onLogoutSpecificDevice);
    on<LogoutAllDeviceEvent>(_onLogoutAllDevice);
  }

  // Initialize devices
  Future<void> _onInitDevices(InitDevicesEvent event, Emitter<DeviceState> emit) async {
    final isSessionCreated = localStorageService.getBool(StorageKeys.isSessionCreated);

    if (isSessionCreated == true) {
      await _fetchDevices(emit);
    } else {
      await _registerDevice(emit);
    }
  }

  // Register device event
  Future<void> _onRegisterDevice(RegisterDevicesEvent event, Emitter<DeviceState> emit) async {
    await _registerDevice(emit);
  }

  // Get devices event
  Future<void> _onGetDevices(GetDevicesEvent event, Emitter<DeviceState> emit) async {
    await _fetchDevices(emit);
  }

  // Register device
  Future<void> _registerDevice(Emitter<DeviceState> emit) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));

    try {
      final DeviceModel responseModel = await authRepository.registerDevice();

      if (responseModel.success == true) {
        await localStorageService.saveBool(StorageKeys.isSessionCreated, true);

        // navigating to accounts screen no need to show device screen
        emit(state.copyWith(
          loadingStatus: LoadingStatus.success,
          isUnderLimit: true
        ));
        // Fetch devices only after successful registration
        // await _fetchDevices(emit);
      } else {
        if(responseModel.deviceList?.length != 0) {
          if(responseModel.error == null && responseModel.maxLimit == null) { // when max limit not reach then only store
            await localStorageService.saveBool(StorageKeys.isSessionCreated, true);
          }

          emit(state.copyWith(
            deviceModel: responseModel,
            loadingStatus: LoadingStatus.success,
            isUnderLimit: false
          ));
        }else {
          emit(state.copyWith(
            loadingStatus: LoadingStatus.failure,
            errorMessage: responseModel.error ?? responseModel.message,
          ));
        }

      }
    } catch (e) {
      emit(state.copyWith(
        loadingStatus: LoadingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // Fetch all devices
  Future<void> _fetchDevices(Emitter<DeviceState> emit) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));

    try {
      final DeviceModel responseModel = await authRepository.getDevices();

      emit(state.copyWith(
        loadingStatus: LoadingStatus.success,
        deviceModel: responseModel,
        isUnderLimit: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingStatus: LoadingStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutSpecificDevice(LogoutSpecificDeviceEvent event, Emitter<DeviceState> emit) async {
    emit(state.copyWith(
      actionLoadingStatus: LoadingStatus.loading,
      selectedDeviceId: event.sessionId,
    ));

    try {
      final response = await authRepository.logoutSpecificUser(
        sessionId: event.sessionId,
      );

      if (response["success"] == true) {
        final currentModel = state.deviceModel;
        final currentDevices = currentModel?.deviceList ?? [];

        // Check whether the device exists before removing it.
        final deviceExists = currentDevices.any(
              (device) => device.id == event.sessionId,
        );

        if (!deviceExists) {
          emit(state.copyWith(
            actionLoadingStatus: LoadingStatus.success,
          ));
          return;
        }

        // Remove the logged-out device.
        final updatedDeviceList = currentDevices
            .where((device) => device.id != event.sessionId)
            .toList();

        // Update the active count.
        final int updatedActiveCount = currentModel?.activeCount != null
            ? (currentModel!.activeCount! - 1).clamp(0, 999999)
            : updatedDeviceList.length;

        final limit = currentModel?.maxLimit;
        final isUnderLimit = limit == null || updatedDeviceList.length < limit;

        // Update the model.
        final updatedModel = currentModel?.copyWith(
          error: isUnderLimit ? null : currentModel.error,
          maxLimit: isUnderLimit ? null : currentModel.maxLimit,
          activeCount: updatedActiveCount,
          deviceList: updatedDeviceList,
        );

        await localStorageService.saveBool(StorageKeys.isSessionCreated, true);

        emit(state.copyWith(
          isUnderLimit: true,
          deviceModel: updatedModel,
          actionLoadingStatus: LoadingStatus.success,
        ));
      } else {
        emit(state.copyWith(
          actionLoadingStatus: LoadingStatus.failure,
          actionErrorMessage:
          response["message"] ?? somethingWentWrong,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        actionLoadingStatus: LoadingStatus.failure,
        actionErrorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutAllDevice(LogoutAllDeviceEvent event, Emitter<DeviceState> emit) async {
    try {
      emit(state.copyWith(
          authType: AuthType.logout,
          actionLoadingStatus: LoadingStatus.loading
      ));

      await authRepository.logout(isAllDevice: true);

      emit(state.copyWith(
        authType: AuthType.logout,
          actionLoadingStatus: LoadingStatus.success,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          authType: AuthType.logout,
          actionLoadingStatus: LoadingStatus.failure,
          actionErrorMessage: e.toString(),
        ),
      );
    }
  }

}