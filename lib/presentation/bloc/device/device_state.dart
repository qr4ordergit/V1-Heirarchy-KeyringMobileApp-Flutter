
import '../../../core/enums/enums.dart';
import '../../../data/models/devices/device_model.dart';

class DeviceState {
  final LoadingStatus loadingStatus;
  final DeviceModel? deviceModel;
  final String? selectedDeviceId;
  final String? errorMessage;
  bool isUnderLimit;

  final AuthType? authType;
  final LoadingStatus actionLoadingStatus;
  final String? actionErrorMessage;

  DeviceState({
    this.loadingStatus = LoadingStatus.initial,
    this.selectedDeviceId,
    this.deviceModel,
    this.errorMessage,
    this.isUnderLimit = false,
    this.actionLoadingStatus = LoadingStatus.initial,
    this.authType,
    this.actionErrorMessage,
  });

  DeviceState copyWith({
    LoadingStatus? loadingStatus,
    DeviceModel? deviceModel,
    String? selectedDeviceId,
    String? errorMessage,
    bool? isUnderLimit,

    AuthType? authType,
    LoadingStatus? actionLoadingStatus,
    String? actionErrorMessage,
  })  => DeviceState(
    loadingStatus: loadingStatus ?? this.loadingStatus,
    deviceModel: deviceModel ?? this.deviceModel,
    selectedDeviceId: selectedDeviceId,
    errorMessage: errorMessage,
    isUnderLimit: isUnderLimit ?? this.isUnderLimit,
    authType: authType ?? this.authType,
    actionLoadingStatus: actionLoadingStatus ?? this.actionLoadingStatus,
    actionErrorMessage: actionErrorMessage,
  );
}