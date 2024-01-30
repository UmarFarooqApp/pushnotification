// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? uid;
  String? email;
  String? phone;
  String? language;
  String? profileUrl;
  List<dynamic>? favoriteList;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.uid,
    this.email,
    this.phone,
    this.language,
    this.profileUrl,
    this.favoriteList,
    this.createdAt,
    this.updatedAt,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? phone,
    String? language,
    String? profileUrl,
    String? password,
    List<dynamic>? favoriteList,
    String? createdAt,
    String? updatedAt,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        language: language ?? this.language,
        profileUrl: profileUrl ?? this.profileUrl,
        favoriteList: favoriteList ?? this.favoriteList,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserModel.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    uid = json["uid"];
    email = json["email"];
    phone = json["phone"];
    language = json["language"];
    profileUrl = json["profileUrl"];
    favoriteList = json["favoriteList"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
        phone: json["phone"],
        language: json["language"],
        profileUrl: json["profileUrl"],
        favoriteList: json["favoriteList"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "phone": phone,
        "language": language,
        "profileUrl": profileUrl,
        "favoriteList": favoriteList,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
