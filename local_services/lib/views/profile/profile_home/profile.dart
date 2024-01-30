import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_cache_network_image.dart';
import 'package:local_services/components/common_textfield.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/controllers/auth_controller.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Get.find<AuthController>().loadPage(true);
      await Get.find<AuthController>().getUserId();
      Get.find<AuthController>().loadPage(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return authController.isLoading.value == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: AppColors.kWhiteColor,
              appBar: commonAppBar(
                onLeadingTap: () {
                  Get.back();
                },
                displayLogo: true,
                context: context,
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.toNamed(routeEditProfile);
                    },
                    child: Text(
                      "edit".tr,
                      style: AppTextStyle.bodyNormal14.copyWith(
                          color: AppColors.kMainColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 34.h,
                      ),

                      authController.user.value?.profileUrl == null ||
                              authController.user.value?.profileUrl == ""
                          ? CircleAvatar(
                              radius: 51.r,
                              backgroundColor: AppColors.kTextPrimaryColor,
                              child: CircleAvatar(
                                radius: 50.r,
                                backgroundColor: AppColors.kWhiteColor,
                                child: SvgPicture.asset(
                                  AppAssets.userIcon,
                                  color: AppColors.kBlackColor,
                                ),
                              ),
                            )
                          : CustomCachedNetworkImage(
                              imgUrl:
                                  authController.user.value?.profileUrl ?? "",
                              height: 100.h,
                              width: 100.h,
                              borderRadius: 50.r,
                              errorImg: AppAssets.logo2Image),

                      CommonTextFieldNew(
                          onSaved: (e) {},
                          validator: (e) {
                            return null;
                          },
                          initialText:
                              authController.user.value?.email.toString(),
                          outerLabel: "email".tr,
                          enabled: false,
                          filled: true),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonTextFieldNew(
                          onSaved: (e) {},
                          validator: (e) {
                            return null;
                          },
                          initialText:
                              authController.user.value?.phone.toString(),
                          outerLabel: "phone_number".tr,
                          enabled: false,
                          filled: true),
                      SizedBox(
                        height: 16.h,
                      ),
                      // CommonTextFieldNew(
                      //     onSaved: (e) {},
                      //     validator: (e) {
                      //       return null;
                      //     },
                      //     initialText: "ABC Town",
                      //     outerLabel: "Address",
                      //     enabled: false,
                      //     filled: true),
                      const Spacer(),
                      CommonButton(
                          onTap: () async {
                            Util.showLoading("Loading");
                            await FirebaseAuth.instance.signOut();
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            sp.setString("uid", "");
                            Util.dismiss();
                            Get.toNamed(routeLogin);
                          },
                          text: "logout".tr,
                          isItalicText: false,
                          isFilled: true,
                          hasIcon: false),

                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
