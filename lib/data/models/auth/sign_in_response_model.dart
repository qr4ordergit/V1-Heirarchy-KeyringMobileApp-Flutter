import 'dart:convert';
SignInResponseModel signInResponseModelFromJson(String str) => SignInResponseModel.fromJson(json.decode(str));

String signInResponseModelToJson(SignInResponseModel data) => json.encode(data.toJson());

class SignInResponseModel {
  int? status;
  bool? success;
  String? message;
  UserDataModel? userData;

  SignInResponseModel({
    this.status,
    this.success,
    this.message,
    this.userData,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) => SignInResponseModel(
    status: json["status"],
    success: json["success"],
    message: json["message"],
    userData: json["data"] == null ? null : UserDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "message": message,
    "data": userData?.toJson(),
  };
}

class UserDataModel {
  String? username; // when sub account user login username: sup-murliapp-208 if Hub login then username: ukr-djphqx-979
  String? userId;
  String? email;
  String? accessToken;
  String? refreshToken;
  String? idToken;
  String? userType;
  List<String>? groupNames; // hub, sub

  UserDataModel({
    this.username,
    this.userId,
    this.email,
    this.accessToken,
    this.refreshToken,
    this.idToken,
    this.userType,
    this.groupNames,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
    username: json["username"],
    userId: json["user_id"],
    email: json["email"],
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    idToken: json["id_token"],
    userType: json["user_type"],
    groupNames: json["group_names"] == null ? [] : List<String>.from(json["group_names"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "user_id": userId,
    "email": email,
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "id_token": idToken,
    "user_type": userType,
    "group_names": groupNames == null ? [] : List<dynamic>.from(groupNames!.map((x) => x)),
  };


}
