import 'package:get/get.dart';
import 'package:local_services/controllers/all_services_controller.dart';
import 'package:local_services/controllers/auth_controller.dart';
import 'package:local_services/controllers/categories_controller.dart';
import 'package:local_services/controllers/cities_controller.dart';
import 'package:local_services/controllers/favorites_controller.dart';
import 'package:local_services/controllers/language_controller.dart';
import 'package:local_services/controllers/location_controller.dart';
import 'package:local_services/controllers/services_controller.dart';
import 'package:local_services/views/about_app/about_app.dart';
import 'package:local_services/views/all_services_list/all_services_list.dart';
import 'package:local_services/views/auth/forgot_password/forgot_password.dart';
import 'package:local_services/views/auth/login_screen/login_screen.dart';
import 'package:local_services/views/auth/register_screen/register_screen.dart';
import 'package:local_services/views/favorites/favorites_screen.dart';
import 'package:local_services/views/language_screen/language_screen.dart';
import 'package:local_services/views/no_internet/no_internet.dart';
import 'package:local_services/views/profile/edit_profile/edit_profile.dart';
import 'package:local_services/views/profile/profile_home/profile.dart';
import 'package:local_services/views/splash/splash_screen.dart';
import 'package:local_services/views/user_services/user_services.dart';

const routeSplash = '/Splash';
const routeLogin = '/Login';
const routeRegister = '/Register';
const routeForgotPassword = '/ForgotPassword';
const routeProfileHome = '/ProfileHome';
const routeAboutApp = '/AboutApp';
const routeEditProfile = '/EditProfile';
const routeLanguageScreen = '/LanguageScreen';
const routeUserServices = '/UserServices';
const routeAllListServices = '/AllListServices';
const routeFavorites = '/Favorites';
const routeNoInternet = '/NoInternet';

class Routes {
  static final routes = [
    GetPage(
      name: routeSplash,
      page: () => const SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
        Get.lazyPut(() => ServiceController());
        Get.lazyPut(() => AllServicesController());
        Get.lazyPut(() => CategoriesController());
        Get.lazyPut(() => LocationController());
        Get.lazyPut(() => CitiesController());
        Get.lazyPut(() => LanguageController());
        Get.lazyPut(() => FavoritesController());
      }),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeLogin,
      page: () => const LoginScreen(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeRegister,
      page: () => const RegisterScreen(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeForgotPassword,
      page: () => const ForgotPasswordScreen(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeAboutApp,
      page: () => const AboutApp(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeProfileHome,
      page: () => const ProfileHome(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeEditProfile,
      page: () => const EditProfile(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeLanguageScreen,
      page: () => const LanguageScreen(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeUserServices,
      page: () => const UserServices(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeAllListServices,
      page: () => const AllServicesList(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeFavorites,
      page: () => const FavoriteServices(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: routeNoInternet,
      page: () => const NoInternet(),
      transitionDuration: const Duration(milliseconds: 0),
      transition: Transition.noTransition,
    ),
  ];
}
