// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ServiceModel serviceModelFromJson(String str) =>
    ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  String? uploadedBy;
  String? title;
  String? serviceId;

  String? description;
  String? category;
  String? phone;
  String? cityName;
  List<dynamic>? searchList;
  String? serviceImageUrl;
  double? longitude;
  double? latitude;
  String? createdAt;
  String? updatedAt;

  ServiceModel({
    this.uploadedBy,
    this.title,
    this.searchList,
    this.serviceId,
    this.description,
    this.category,
    this.phone,
    this.cityName,
    this.serviceImageUrl,
    this.longitude,
    this.latitude,
    this.createdAt,
    this.updatedAt,
  });

  ServiceModel copyWith({
    String? uploadedBy,
    String? title,
    String? description,
    String? category,
    String? phone,
    String? cityName,
    String? serviceId,
    String? serviceImageUrl,
    double? longitude,
    required List<dynamic> searchList,
    double? latitude,
    String? createdAt,
    String? updatedAt,
  }) =>
      ServiceModel(
        uploadedBy: uploadedBy ?? this.uploadedBy,
        title: title ?? this.title,
        description: description ?? this.description,
        category: category ?? this.category,
        phone: phone ?? this.phone,
        cityName: cityName ?? this.cityName,
        serviceImageUrl: serviceImageUrl ?? this.serviceImageUrl,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        searchList: searchList,
        serviceId: serviceId ?? this.serviceId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        uploadedBy: json["uploadedBy"],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        phone: json["phone"],
        cityName: json["cityName"],
        serviceId: json["serviceId"],
        serviceImageUrl: json["serviceImageUrl"],
        searchList: json["searchList"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  ServiceModel.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    uploadedBy = json["uploadedBy"];
    title = json["title"];
    phone = json["phone"];
    serviceId = json["serviceId"];
    cityName = json["cityName"];
    description = json["description"];
    searchList = json["searchList"];
    category = json["category"];
    serviceImageUrl = json["serviceImageUrl"];
    longitude = json["longitude"];
    latitude = json["latitude"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }
  Map<String, dynamic> toJson() => {
        "uploadedBy": uploadedBy,
        "title": title,
        "description": description,
        "category": category,
        "phone": phone,
        "cityName": cityName,
        "serviceId": serviceId,
        "searchList": searchList,
        "serviceImageUrl": serviceImageUrl,
        "longitude": longitude,
        "latitude": latitude,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
