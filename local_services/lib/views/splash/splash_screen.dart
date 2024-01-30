import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/controllers/categories_controller.dart';
import 'package:local_services/controllers/cities_controller.dart';
import 'package:local_services/controllers/language_controller.dart';
import 'package:local_services/controllers/location_controller.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/utils/constants.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool check = await internetAvailabilityCheck(false);
      if (check) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String? uid = sharedPreferences.getString("uid");
        String? language = sharedPreferences.getString("language");
        if (language == null) {
          setState(() {
            initialLanguage = "english";
          });
          Get.find<LanguageController>().updateLanguage("english");
        } else {
          setState(() {
            initialLanguage = language.toString();
          });
          Get.find<LanguageController>().updateLanguage(language.toString());
        }
        bool allCat = await Get.find<CategoriesController>().getAllCategories();
        bool allCities = await Get.find<CitiesController>().getAllCities();

        bool isLocationOn =
            await Get.find<LocationController>().getCurrentPosition();

        if (allCat == true && isLocationOn == true && allCities) {
          if (uid == null || uid == "") {
            Get.offAllNamed(routeAllListServices);
          } else {
            Get.offAllNamed(routeAllListServices);
          }
        }
      } else {
        Get.offAllNamed(routeNoInternet);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kMainColor,
      body: SafeArea(
        child: Center(
          child: Image.asset(AppAssets.logoImage),
        ),
      ),
    );
  }
}
