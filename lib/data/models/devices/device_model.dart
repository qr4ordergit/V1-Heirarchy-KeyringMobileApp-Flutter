import 'dart:convert';

DeviceModel deviceModelFromJson(String str) => DeviceModel.fromJson(json.decode(str));

String deviceModelToJson(DeviceModel data) => json.encode(data.toJson());

class DeviceModel {
  bool? success;
  String? error;
  String? message;
  int? activeCount;
  int? maxLimit;
  List<DeviceList>? deviceList;

  DeviceModel({
    this.success,
    this.error,
    this.message,
    this.activeCount,
    this.maxLimit,
    this.deviceList,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
    success: json["success"],
    error: json["error"],
    message: json["message"],
    activeCount: json["active_count"],
    maxLimit: json["max_limit"],
    deviceList: json["Device_List"] == null ? [] : List<DeviceList>.from(json["Device_List"]!.map((x) => DeviceList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "message": message,
    "active_count": activeCount,
    "max_limit": maxLimit,
    "Device_List": deviceList == null ? [] : List<dynamic>.from(deviceList!.map((x) => x.toJson())),
  };

  DeviceModel copyWith({
    bool? success,
    String? error,
    String? message,
    int? activeCount,
    int? maxLimit,
    List<DeviceList>? deviceList,
    List<DeviceList>? activeDevices,
  }) {
    return DeviceModel(
      success: success ?? this.success,
      error: error ?? this.error,
      message: message ?? this.message,
      activeCount: activeCount ?? this.activeCount,
      maxLimit: maxLimit ?? this.maxLimit,
      deviceList: deviceList ?? this.deviceList,
    );
  }
}

class DeviceList {
  String? id;
  String? username;
  String? deviceName;
  String? platform;
  String? browser;
  String? refreshTokenEncrypted;
  CreatedAt? createdAt;
  bool? status;
  dynamic revokedAt;
  String? appId;

  DeviceList({
    this.id,
    this.username,
    this.deviceName,
    this.platform,
    this.browser,
    this.refreshTokenEncrypted,
    this.createdAt,
    this.status,
    this.revokedAt,
    this.appId,
  });

  factory DeviceList.fromJson(Map<String, dynamic> json) => DeviceList(
    id: json["_id"],
    username: json["username"],
    deviceName: json["device_name"],
    platform: json["platform"],
    browser: json["browser"],
    refreshTokenEncrypted: json["refresh_token_encrypted"],
    createdAt: json["created_at"] == null ? null : CreatedAt.fromJson(json["created_at"]),
    status: json["status"],
    revokedAt: json["revoked_at"],
    appId: json["app_id"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "device_name": deviceName,
    "platform": platform,
    "browser": browser,
    "refresh_token_encrypted": refreshTokenEncrypted,
    "created_at": createdAt?.toJson(),
    "status": status,
    "revoked_at": revokedAt,
    "app_id": appId,
  };

  DeviceList copyWith({
    String? id,
    String? username,
    String? deviceName,
    String? platform,
    String? browser,
    String? refreshTokenEncrypted,
    CreatedAt? createdAt,
    bool? status,
    dynamic revokedAt,
    String? appId,
  }) {
    return DeviceList(
      id: id ?? this.id,
      username: username ?? this.username,
      deviceName: deviceName ?? this.deviceName,
      platform: platform ?? this.platform,
      browser: browser ?? this.browser,
      refreshTokenEncrypted:
      refreshTokenEncrypted ?? this.refreshTokenEncrypted,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      revokedAt: revokedAt ?? this.revokedAt,
      appId: appId ?? this.appId,
    );
  }
}
class CreatedAt {
  String? date;

  CreatedAt({this.date});

  factory CreatedAt.fromJson(Map<String, dynamic> json) {
    return CreatedAt(
      date: json['\$date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '\$date': date,
  };

  CreatedAt copyWith({String? date}) {
    return CreatedAt(
      date: date ?? this.date,
    );
  }
}