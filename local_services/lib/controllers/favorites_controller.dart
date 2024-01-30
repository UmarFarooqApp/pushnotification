import 'dart:developer';

import 'package:get/get.dart';
import 'package:local_services/config/firestore.dart';
import 'package:local_services/model/service_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends GetxController implements GetxService {
  final RxList<dynamic> serviceFavoriteList = <dynamic>[].obs;
  RxList<ServiceModel> favoriteServices = <ServiceModel>[].obs;
  RxBool isLoading = true.obs;
  Future<bool> addToFavorite(String favsData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");
    List<dynamic>? allFavs = await FirestoreService().getFavorites(uid ?? "");

    if (allFavs == []) {
      serviceFavoriteList.value = [];
      ServiceModel serviceModelData =
          await FirestoreService().getServicesByServiceId(favsData);
      favoriteServices.add(serviceModelData);
      update();
      bool data = await FirestoreService().addFavorites(uid ?? "", [favsData]);
      if (data == true) {
        return true;
      } else {
        return false;
      }
    } else {
      allFavs.add(favsData);
      serviceFavoriteList.value = allFavs;
      List<ServiceModel> dataTemp = [];
      for (var i = 0; i < allFavs.length; i++) {
        ServiceModel serviceModelData =
            await FirestoreService().getServicesByServiceId(allFavs[i]);
        dataTemp.add(serviceModelData);
      }
      favoriteServices.value = dataTemp;
      update();
      bool data = await FirestoreService().addFavorites(uid ?? "", allFavs);
      if (data == true) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> removeFromFavorite(String favsData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");
    List<dynamic>? allFavs = await FirestoreService().getFavorites(uid ?? "");

    allFavs.remove(favsData);
    serviceFavoriteList.value = allFavs;
    List<ServiceModel> dataTemp = [];
    for (var i = 0; i < allFavs.length; i++) {
      ServiceModel serviceModelData =
          await FirestoreService().getServicesByServiceId(allFavs[i]);
      dataTemp.add(serviceModelData);
    }
    log("$dataTemp");
    favoriteServices.value = dataTemp;
    update();
    bool data = await FirestoreService().addFavorites(uid ?? "", dataTemp);
    if (data == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getAllFavorite() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? uid = sharedPreferences.getString("uid");
      List<dynamic>? allFavs = await FirestoreService().getFavorites(uid ?? "");
      // log(allFavs.toString());
      if (allFavs == []) {
        return true;
      } else {
        serviceFavoriteList.value = allFavs;
        List<ServiceModel> dataTemp = [];
        log("====MMMMMM $serviceFavoriteList");
        for (var i = 0; i < allFavs.length; i++) {
          log("ii $i ---  ${allFavs.length} -- ${allFavs[i]}");
          ServiceModel serviceModelData = await FirestoreService()
              .getServicesByServiceId(allFavs[i].toString());
          dataTemp.add(serviceModelData);
        }
        log("===> $dataTemp");
        favoriteServices.value = dataTemp;
        update();
        return true;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  void loadPage(bool value) {
    isLoading.value = value;
    update();
  }
}
