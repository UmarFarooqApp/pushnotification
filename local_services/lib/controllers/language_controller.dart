import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController implements GetxService {
  RxString language = "english".obs;

  updateLanguage(String lang) {
    language.value = lang;

    Get.updateLocale(language.value == "english"
        ? const Locale('en', "US")
        : language.value == "french"
            ? const Locale('fr', "FR")
            : const Locale('ar', 'SA'));

    log(language.toString());
    update();
  }
}
