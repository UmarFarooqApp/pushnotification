import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_translations.dart';
import 'package:local_services/utils/constants.dart';
import 'package:local_services/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.kMainColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.kMainColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: ScreenUtilInit(
        builder: ((context, child) {
          final easyLoading = EasyLoading.init();
          return GetMaterialApp(
            locale: const Locale('en', 'US'),
            // locale: initialLanguage == "english"
            //     ? const Locale('en', 'US')
            //     : initialLanguage == "french"
            //         ? Locale('fr', 'FR')
            //         : Locale('ar', 'SA'),
            translations: AppTranslations(),
            fallbackLocale: const Locale('fr', 'FR'),
            theme: ThemeData(
              textTheme: GoogleFonts.readexProTextTheme(),
            ),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              ScreenUtil.init(
                context,
                designSize: const Size(375, 812),
              );
              child = easyLoading(context, child);
              Util.setEasyLoading();
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
                child: child,
              );
            },
            getPages: Routes.routes,
            initialRoute: routeSplash,
            defaultTransition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 300),
          );
        }),
      ),
    );
  }
}
