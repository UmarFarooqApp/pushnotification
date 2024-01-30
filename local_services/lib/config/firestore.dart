import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/controllers/location_controller.dart';
import 'package:local_services/model/service_model.dart';
import 'package:local_services/model/user_model.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<bool> createUser({required UserModel userModel}) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        _fireStore
            .collection("users")
            .doc(userModel.uid)
            .set(userModel.toJson());
        return true;
      } catch (e) {
        log("********* Exception In: addUserToCollection from catch  *********");
        log(e.toString());
        Util.showErrorSnackBar(e.toString());
        return false;
      }
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return false;
    }
  }

  Future<bool> updateUser({required UserModel userModel}) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        _fireStore
            .collection("users")
            .doc(userModel.uid)
            .set(userModel.toJson());
        return true;
      } catch (e) {
        log("********* Exception In: updateUser from catch  *********");
        log(e.toString());
        Util.showErrorSnackBar(e.toString());
        return false;
      }
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return false;
    }
  }

  Future<bool> updateLanguageOfUser(
      {required String language, required String uid}) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        _fireStore.collection("users").doc(uid).update({"language": language});
        sharedPreferences.setString('language', language);
        return true;
      } catch (e) {
        log("********* Exception In: updateLanguageOfUser from catch  *********");
        log(e.toString());
        Util.showErrorSnackBar(e.toString());
        return false;
      }
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return false;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    return _fireStore
        .collection("users")
        .doc(uid)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((doc) async {
      if (doc.exists) {
        log("inside doc.exists");
        return UserModel.fromFireStore(doc);
      } else {
        log("inside else doc exisits");
        return null;
      }
    });
  }

  Future<bool> addService(
      {required ServiceModel serviceModel, required serviceId}) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        _fireStore
            .collection("services")
            .doc(serviceId)
            .set(serviceModel.toJson());
        return true;
      } catch (e) {
        log("********* Exception In: addService from catch  *********");
        log(e.toString());
        Util.showErrorSnackBar(e.toString());
        return false;
      }
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return false;
    }
  }

  Future<bool> updateServices({required ServiceModel serviceModel}) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      try {
        _fireStore
            .collection("services")
            .doc(serviceModel.serviceId)
            .set(serviceModel.toJson());
        return true;
      } catch (e) {
        log("********* Exception In: updateServices from catch  *********");
        log(e.toString());
        Util.showErrorSnackBar(e.toString());
        return false;
      }
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return false;
    }
  }

  Future<List<ServiceModel>?> getServicesById(String uid) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      List<ServiceModel>? listOfServicesModel;
      return _fireStore
          .collection("services")
          .where("uploadedBy", isEqualTo: uid)
          .get(const GetOptions(source: Source.serverAndCache))
          .then((doc) async {
        listOfServicesModel = (doc.docs)
            .map(
              (e) => ServiceModel.fromFireStore(e),
            )
            .toList();
        log(listOfServicesModel.toString());

        return listOfServicesModel;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return null;
    }
  }

  Future<ServiceModel> getServicesByServiceId(String serviceId) async {
    ServiceModel servicesModelReceived;
    return _fireStore
        .collection("services")
        .doc(serviceId)
        .get(const GetOptions(source: Source.serverAndCache))
        .then((doc) async {
      servicesModelReceived = ServiceModel.fromFireStore(doc);

      return servicesModelReceived;
    });
  }

  Future<bool> addFavorites(String uid, List<dynamic> listOfFavs) async {
    try {
      _fireStore
          .collection("users")
          .doc(uid)
          .update({"favoriteList": listOfFavs});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getFavorites(
    String uid,
  ) async {
    List<dynamic> listOfFavs = [];
    try {
      await _fireStore.collection("users").doc(uid).get().then((value) {
        listOfFavs = value['favoriteList'];
      });

      return listOfFavs;
    } catch (e) {
      log(e.toString());
      return listOfFavs;
    }
  }

  Future<List<ServiceModel>?> getAllServices(String uid) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      List<ServiceModel>? listOfServicesModel;
      return _fireStore
          .collection("services")
          .where("uploadedBy", isNotEqualTo: uid)
          .where("cityName",
              isEqualTo: Get.find<LocationController>().cityName.value)
          .get(const GetOptions(source: Source.serverAndCache))
          .then((doc) async {
        listOfServicesModel = (doc.docs)
            .map(
              (e) => ServiceModel.fromFireStore(e),
            )
            .toList();
        log(listOfServicesModel.toString());

        return listOfServicesModel;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return null;
    }
  }

  Future<List<ServiceModel>?> getServicesByCategory(
      String uid, String categoryName, String cityName) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      List<ServiceModel>? listOfServicesModel;
      return _fireStore
          .collection("services")
          .where("uploadedBy", isNotEqualTo: uid)
          .where("category", isEqualTo: categoryName)
          .where("cityName", isEqualTo: cityName)
          .get(const GetOptions(source: Source.serverAndCache))
          .then((doc) async {
        listOfServicesModel = (doc.docs)
            .map(
              (e) => ServiceModel.fromFireStore(e),
            )
            .toList();
        log(listOfServicesModel.toString());

        return listOfServicesModel;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return null;
    }
  }

  Future<List<ServiceModel>?> getServicesByCityName(
      String uid, String cityName) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      List<ServiceModel>? listOfServicesModel;
      return _fireStore
          .collection("services")
          .where("uploadedBy", isNotEqualTo: uid)
          .where("cityName", isEqualTo: cityName)
          .get(const GetOptions(source: Source.serverAndCache))
          .then((doc) async {
        listOfServicesModel = (doc.docs)
            .map(
              (e) => ServiceModel.fromFireStore(e),
            )
            .toList();
        log(listOfServicesModel.toString());

        return listOfServicesModel;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return null;
    }
  }

  Future<List<String>?> getAllCategories() async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      List<String>? listOfCategories;
      return _fireStore
          .collection("category")
          .get(const GetOptions(source: Source.serverAndCache))
          .then((doc) async {
        listOfCategories = (doc.docs)
            .map(
              (e) => e['category_name'].toString(),
            )
            .toList();
        log(listOfCategories.toString());

        return listOfCategories;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return null;
    }
  }

  Future<List<String>?> getAllCities() async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      List<String>? listOfCities;
      return _fireStore
          .collection("cities")
          .get(const GetOptions(source: Source.serverAndCache))
          .then((doc) async {
        listOfCities = (doc.docs)
            .map(
              (e) => e['name'].toString(),
            )
            .toList();
        log(listOfCities.toString());

        return listOfCities;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return null;
    }
  }

  Future<List<ServiceModel>?> searchServices(
      String uid, String searchQuery) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      List<ServiceModel>? listOfServicesModel;
      return _fireStore
          .collection("services")
          .where("uploadedBy", isNotEqualTo: uid)
          .where("searchList", arrayContains: searchQuery)
          .get(const GetOptions(source: Source.serverAndCache))
          .then((doc) async {
        listOfServicesModel = (doc.docs)
            .map(
              (e) => ServiceModel.fromFireStore(e),
            )
            .toList();
        log(listOfServicesModel.toString());

        return listOfServicesModel;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return null;
    }
  }

  Future<bool> deleteService({required String serviceId}) async {
    bool internetAvailable = await internetAvailabilityCheck(false);
    if (internetAvailable) {
      return _fireStore
          .collection("services")
          .doc(serviceId)
          .delete()
          .then((doc) async {
        return true;
      });
    } else {
      Util.showErrorSnackBar("No Internet Available");
      Get.toNamed(routeNoInternet);
      return false;
    }
  }
}
