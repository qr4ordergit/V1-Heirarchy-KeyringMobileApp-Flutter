import 'dart:convert';

KeyringModel keyringModelFromJson(String str) => KeyringModel.fromJson(json.decode(str));

String keyringModelToJson(KeyringModel data) => json.encode(data.toJson());

class KeyringModel {
  bool? success;
  List<KeyringData>? data;

  KeyringModel({
    this.success,
    this.data,
  });

  factory KeyringModel.fromJson(Map<String, dynamic> json) => KeyringModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<KeyringData>.from(json["data"]!.map((x) => KeyringData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class KeyringData {
  String? id;
  String? keyringCategoryName;
  Map<String, dynamic>? keyringCategoryPasswords;
  dynamic parentCategoryId;
  String? createdBy;
  bool? twoFa;
  String? secretKey;
  String? createdOn;
  List<dynamic>? childCategoryIds;

  KeyringData({
    this.id,
    this.keyringCategoryName,
    this.keyringCategoryPasswords,
    this.parentCategoryId,
    this.createdBy,
    this.twoFa,
    this.secretKey,
    this.createdOn,
    this.childCategoryIds,
  });

  KeyringData copyWith({
    String? id,
    String? keyringCategoryName,
    Map<String, dynamic>? keyringCategoryPasswords,
    dynamic parentCategoryId,
    String? createdBy,
    bool? twoFa,
    String? secretKey,
    String? createdOn,
    List<dynamic>? childCategoryIds,
  }) =>
      KeyringData(
        id: id ?? this.id,
        keyringCategoryName: keyringCategoryName ?? this.keyringCategoryName,
        keyringCategoryPasswords: keyringCategoryPasswords ?? this.keyringCategoryPasswords,
        parentCategoryId: parentCategoryId ?? this.parentCategoryId,
        createdBy: createdBy ?? this.createdBy,
        twoFa: twoFa ?? this.twoFa,
        secretKey: secretKey ?? this.secretKey,
        createdOn: createdOn ?? this.createdOn,
        childCategoryIds: childCategoryIds ?? this.childCategoryIds,
      );

  factory KeyringData.fromJson(Map<String, dynamic> json) => KeyringData(
    id: json["_id"],
    keyringCategoryName: json["keyring_category_name"],
    keyringCategoryPasswords: json["keyring_category_passwords"] == null ? {} : Map<String, dynamic>.from(json["keyring_category_passwords"]),
    parentCategoryId: json["parent_category_id"],
    createdBy: json["created_by"],
    twoFa: json["2fa"],
    secretKey: json["secret_key"],
    createdOn: json["created_on"],
    childCategoryIds: json["child_category_ids"] == null ? [] : List<dynamic>.from(json["child_category_ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "keyring_category_name": keyringCategoryName,
    "keyring_category_passwords": keyringCategoryPasswords,
    "parent_category_id": parentCategoryId,
    "created_by": createdBy,
    "2fa": twoFa,
    "secret_key": secretKey,
    "created_on": createdOn,
    "child_category_ids": childCategoryIds == null ? [] : List<dynamic>.from(childCategoryIds!.map((x) => x)),
  };
}