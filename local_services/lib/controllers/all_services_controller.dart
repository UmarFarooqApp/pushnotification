import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:local_services/config/firestore.dart';
import 'package:local_services/model/service_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllServicesController extends GetxController implements GetxService {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<ServiceModel> allServices = <ServiceModel>[].obs;
  RxBool isLoading = true.obs;
  Future<bool> getAllServices() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");

    return await FirestoreService()
        .getAllServices(uid ?? "")
        .then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        allServices.value = serviceData;
        update();
        return true;
      }
    });
  }

  Future<bool> getAllServicesByCategoryName(
      String categoryName, String cityName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");

    return await FirestoreService()
        .getServicesByCategory(uid ?? "", categoryName, cityName)
        .then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        allServices.value = serviceData;
        update();
        return true;
      }
    });
  }

  Future<bool> getAllServicesByCityName(String cityName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");

    return await FirestoreService()
        .getServicesByCityName(uid ?? "", cityName)
        .then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        allServices.value = serviceData;
        update();
        return true;
      }
    });
  }

  Future<bool> searchServices(String searchQuery) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");
    return await FirestoreService()
        .searchServices(uid ?? "", searchQuery)
        .then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        allServices.value = serviceData;
        update();
        return true;
      }
    });
  }

  void loadPage(bool value) {
    isLoading.value = value;
    update();
  }
}
