import 'dart:developer';

import 'package:get/get.dart';
import 'package:local_services/config/firestore.dart';

class CitiesController extends GetxController implements GetxService {
  RxList<String> allCities = <String>[].obs;
  RxBool isLoading = true.obs;

  Future<bool> getAllCities() async {
    return await FirestoreService().getAllCities().then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        allCities.value = serviceData;
        allCities.insert(0, "Current Location");
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
