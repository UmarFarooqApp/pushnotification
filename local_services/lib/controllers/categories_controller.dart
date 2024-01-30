import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:local_services/config/firestore.dart';

class CategoriesController extends GetxController implements GetxService {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<String> allCategories = <String>[].obs;
  RxBool isLoading = true.obs;

  Future<bool> getAllCategories() async {
    return await FirestoreService()
        .getAllCategories()
        .then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        allCategories.value = serviceData;
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
