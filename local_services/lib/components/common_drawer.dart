import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';

class CommonDrawer extends StatelessWidget {
  final GlobalKey scaffoldKey;
  const CommonDrawer({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.kMainColor,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.kMainColor,
            ), //BoxDecoration
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: SvgPicture.asset(
                    AppAssets.backButtonIcon,
                    color: AppColors.kWhiteColor,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Image.asset(AppAssets.logoImage)
              ],
            ), //UserAccountDrawerHeader
          ), //DrawerHeader
          ListTile(
            title: Text(
              'profile'.tr,
              style: AppTextStyle.bodyNormal16.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.kWhiteColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: AppColors.kWhiteColor, size: 16.h),
            onTap: () async {
              bool status = await checkLoginStatus();
              if (status == true) {
                Get.toNamed(routeProfileHome);
              } else {
                // Util.showErrorSnackBar("Please Sign in or Make an account!");
                Get.toNamed(routeLogin);
              }
            },
          ),
          ListTile(
            title: Text(
              "Favorites",
              style: AppTextStyle.bodyNormal16.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.kWhiteColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: AppColors.kWhiteColor, size: 16.h),
            onTap: () async {
              bool status = await checkLoginStatus();
              if (status == true) {
                Get.toNamed(routeFavorites);
              } else {
                Util.showErrorSnackBar("Please Sign in or Make an account!");
                Get.toNamed(routeLogin);
              }
            },
          ),
          ListTile(
            title: Text(
              'added_services'.tr,
              style: AppTextStyle.bodyNormal16.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.kWhiteColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: AppColors.kWhiteColor, size: 16.h),
            onTap: () {
              Get.toNamed(routeUserServices);
            },
          ),
          ListTile(
            title: Text(
              'language'.tr,
              style: AppTextStyle.bodyNormal16.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.kWhiteColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: AppColors.kWhiteColor, size: 16.h),
            onTap: () async {
              bool status = await checkLoginStatus();
              if (status == true) {
                Get.toNamed(routeLanguageScreen);
              } else {
                Util.showErrorSnackBar("Please Sign in or Make an account!");
                Get.toNamed(routeLogin);
              }
            },
          ),
          ListTile(
            title: Text(
              'about'.tr,
              style: AppTextStyle.bodyNormal16.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.kWhiteColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: AppColors.kWhiteColor, size: 16.h),
            onTap: () {
              Get.toNamed(routeAboutApp);
            },
          ),
          ListTile(
            title: Text(
              'share_app'.tr,
              style: AppTextStyle.bodyNormal16.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.kWhiteColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: AppColors.kWhiteColor, size: 16.h),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'rate_app'.tr,
              style: AppTextStyle.bodyNormal16.copyWith(
                  fontWeight: FontWeight.w500, color: AppColors.kWhiteColor),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: AppColors.kWhiteColor, size: 16.h),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
