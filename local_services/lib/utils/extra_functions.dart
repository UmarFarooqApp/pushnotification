import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String? emailValidator(String? value, String? validationError) {
  value = value.toString().trim();

  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field".tr;
  } else if (!value.contains("@") || !value.contains(".")) {
    return "Invalid Email";
  } else if (value.contains(" ")) {
    return 'email_contain_white_space'.tr;
  }
  return null;
}

String? passwordValidator(String? value, String? validationError) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])';
  RegExp regExp = RegExp(pattern);
  value = value.toString().trim();
  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field".tr;
  } else if (value.length < 8) {
    return "password_must_greater_than_8".tr;
  } else if (regExp.hasMatch(value) == false) {
    return "password_should_contain_both_upper_and_lower_character".tr;
  }
  return null;
}

String? phoneValidator(String? value, String? validationError) {
  value = value.toString().trim();
  String temp;
  if (value.contains("+")) {
    temp = value.replaceAll("+", "");
  } else {
    temp = value;
  }
  if (value == 'null' || value.isEmpty) {
    return validationError ?? "empty_field".tr;
  } else if (!temp.isNumericOnly) {
    return "phone_no_should_be_number_only".tr;
  } else if (value.length != 12) {
    return "phone_no_should_be_12".tr;
  } else {
    return null;
  }
}

Future<bool> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Util.showErrorSnackBar(
        "Location services are disabled. Please enable the services");
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Util.showErrorSnackBar("Location permissions are denied");
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    Util.showErrorSnackBar(
        "Location permissions are permanently denied, we cannot request permissions.");

    return false;
  }
  return true;
}

Future<bool> checkLoginStatus() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? uid = sharedPreferences.getString("uid");
  if (uid == "" || uid == null) {
    return false;
  } else {
    return true;
  }
}

void launchPhone(String phone) async {
  final uri = Uri(scheme: 'tel', path: phone);
  try {
    await launchUrl(uri);
  } catch (e) {
    log(e.toString());
  }
}

void launchWhatsApp(
  int phone,
) async {
  try {
    String url() {
      if (Platform.isAndroid) {
        return "https://api.whatsapp.com/send?phone=$phone";
      } else {
        return "https://api.whatsapp.com/send?phone=$phone";
      }
    }

    await launchUrl(
        Uri.parse(
          url(),
        ),
        mode: LaunchMode.externalApplication);
  } catch (e) {
    log(e.toString());
  }
}

Future<bool> internetAvailabilityCheck(bool fromInternetCheckScreen) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.ethernet ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    if (fromInternetCheckScreen == false) {
      Get.offAllNamed(routeNoInternet);
    }
    return false;
  }
}
