import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:local_services/config/firebase_storage.dart';
import 'package:local_services/config/firestore.dart';
import 'package:local_services/controllers/location_controller.dart';
import 'package:local_services/model/service_model.dart';
import 'package:local_services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ServiceController extends GetxController implements GetxService {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<ServiceModel> servicesByMeList = <ServiceModel>[].obs;
  RxBool isLoading = true.obs;

  Future<dynamic> addServicesToFirebase(
      {required ServiceModel serviceModel, required File? imageUrl}) async {
    try {
      Util.showLoading("Uploading..");
      String imageUrlData = "";
      final String serviceId = const Uuid().v4();
      if (imageUrl != null) {
        imageUrlData = await FirebaseStorageService().addServicesImageToStorage(
            imageUrl: imageUrl, userId: auth.currentUser!.uid);
      }
      serviceModel = serviceModel.copyWith(
        title: serviceModel.title,
        description: serviceModel.description,
        phone: serviceModel.phone,
        category: serviceModel.category,
        serviceId: serviceId,
        serviceImageUrl: imageUrl != null ? imageUrlData : "",
        longitude: Get.find<LocationController>().currentPosition.longitude,
        latitude: Get.find<LocationController>().currentPosition.latitude,
        cityName: serviceModel.cityName.toString().toLowerCase(),
        searchList: serviceModel.searchList ?? [],
        createdAt: DateTime.now().toString(),
        uploadedBy: auth.currentUser!.uid,
        updatedAt: DateTime.now().toString(),
      );
      await FirestoreService()
          .addService(serviceModel: serviceModel, serviceId: serviceId);

      return true;
    } on FirebaseAuthException catch (e) {
      log("********* Exception In: addServicesToFirebase from FB  *********");
      log(e.toString());
      Util.checkFirebaseException(e.code);
      return false;
    } catch (e) {
      log("********* Exception In: addServicesToFirebase from catch  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return false;
    }
  }

  Future<bool> getServicesById() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");

    return await FirestoreService()
        .getServicesById(uid ?? "")
        .then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        servicesByMeList.value = serviceData;
        update();
        return true;
      }
    });
  }

  Future<bool> getFavoriteServicesById() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? uid = sharedPreferences.getString("uid");

    return await FirestoreService()
        .getServicesById(uid ?? "")
        .then((serviceData) async {
      if (serviceData == null) {
        log("2 ${serviceData.toString()}");

        return false;
      } else {
        log("3 ${serviceData.toString()}");
        servicesByMeList.value = serviceData;
        update();
        return true;
      }
    });
  }

  Future<bool> deleteServieById({required String serviceId}) async {
    return await FirestoreService()
        .deleteService(serviceId: serviceId)
        .then((serviceData) async {
      if (serviceData == true) {
        update();

        return true;
      } else {
        update();
        return false;
      }
    });
  }

  Future<dynamic> updateService(
      {required ServiceModel serviceModel,
      required File? imageUrl,
      required String serviceId}) async {
    try {
      String imageUrlData = "";
      if (imageUrl != null) {
        imageUrlData = await FirebaseStorageService().addServicesImageToStorage(
            imageUrl: imageUrl, userId: auth.currentUser!.uid);
      }

      if (imageUrlData != "") {
        serviceModel = serviceModel.copyWith(
          title: serviceModel.title,
          description: serviceModel.description,
          phone: serviceModel.phone,
          category: serviceModel.category,
          serviceId: serviceId,
          serviceImageUrl: imageUrlData,
          longitude: Get.find<LocationController>().currentPosition.longitude,
          latitude: Get.find<LocationController>().currentPosition.latitude,
          cityName: serviceModel.cityName.toString().toLowerCase(),
          searchList: serviceModel.searchList ?? [],
          createdAt: DateTime.now().toString(),
          uploadedBy: auth.currentUser!.uid,
          updatedAt: DateTime.now().toString(),
        );

        bool temp =
            await FirestoreService().updateServices(serviceModel: serviceModel);
        if (temp) {
          return true;
        } else {
          return false;
        }
      } else {
        log("No Image selected -> ${serviceModel.serviceImageUrl}");

        serviceModel = serviceModel.copyWith(
          title: serviceModel.title,
          description: serviceModel.description,
          phone: serviceModel.phone,
          category: serviceModel.category,
          serviceId: serviceId,
          serviceImageUrl: serviceModel.serviceImageUrl,
          longitude: Get.find<LocationController>().currentPosition.longitude,
          latitude: Get.find<LocationController>().currentPosition.latitude,
          cityName: serviceModel.cityName.toString().toLowerCase(),
          searchList: serviceModel.searchList ?? [],
          createdAt: DateTime.now().toString(),
          uploadedBy: auth.currentUser!.uid,
          updatedAt: DateTime.now().toString(),
        );
        //Todo Check UserController save value of this User.
        bool temp =
            await FirestoreService().updateServices(serviceModel: serviceModel);
        if (temp) {
          return true;
        } else {
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      log("********* Exception In: updateService from FB  *********");
      log(e.toString());
      Util.checkFirebaseException(e.code);
      return false;
    } catch (e) {
      log("********* Exception In: updateService from catch  *********");
      log(e.toString());
      Util.showErrorSnackBar(e.toString());
      return false;
    }
  }

  void loadPage(bool value) {
    isLoading.value = value;
    update();
  }
}
