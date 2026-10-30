abstract class DeviceEvent {}

class InitDevicesEvent extends DeviceEvent {}

class RegisterDevicesEvent extends DeviceEvent {}

class LogoutSpecificDeviceEvent extends DeviceEvent {
  final String sessionId;
  LogoutSpecificDeviceEvent({required this.sessionId});
}

class LogoutAllDeviceEvent extends DeviceEvent {}
class GetDevicesEvent extends DeviceEvent {}
