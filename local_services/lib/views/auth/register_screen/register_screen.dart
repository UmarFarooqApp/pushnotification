import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_dropdown.dart';
import 'package:local_services/components/common_textfield.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/controllers/auth_controller.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/model/local/signup_model.dart';
import 'package:local_services/model/user_model.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  SignUpModel signUpModel =
      SignUpModel(email: "", password: "", phone: "", language: "");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(showBackButton: true, context: context),
      backgroundColor: AppColors.kWhiteColor,
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: IntrinsicHeight(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Image.asset(
                  AppAssets.logo2Image,
                  height: 51.h,
                  width: 184.w,
                  color: AppColors.kMainColor,
                ),
                SizedBox(
                  height: 24.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Text(
                    "Connecting Locals with Trusted Services for Every Need, Instantly.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyNormal14
                        .copyWith(color: AppColors.kTextSecondaryColor),
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                CommonTextFieldNew(
                    onSaved: (e) {
                      signUpModel.email = e.toString();
                    },
                    validator: (e) {
                      return emailValidator(e, "Enter A Valid Email");
                    },
                    inputType: TextInputType.emailAddress,
                    hintText: "Email Address",
                    outerLabel: "Enter Email Address",
                    filled: true),
                SizedBox(
                  height: 16.h,
                ),
                CommonTextFieldNew(
                    onSaved: (e) {
                      signUpModel.phone = e.toString();
                    },
                    validator: (e) {
                      return phoneValidator(e, "Enter A Valid Phone");
                    },
                    inputType: TextInputType.number,
                    hintText: "Phone Number",
                    outerLabel: "Enter Phone Number",
                    filled: true),
                SizedBox(
                  height: 16.h,
                ),
                CommonDropdownButton(
                  label: "Select Language",
                  showBorder: true,
                  showOffset: false,
                  hintText: "Select Language",
                  items: const ["English", "French", "Arabic"],
                  onSaved: (e) {
                    signUpModel.language = e.toString().toLowerCase();
                  },
                  onChange: (e) {
                    signUpModel.language = e.toString().toLowerCase();
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                CommonTextFieldNew(
                    onSaved: (e) {
                      signUpModel.password = e.toString();
                    },
                    validator: (e) {
                      return passwordValidator(e, "Enter A Valid Password");
                    },
                    hintText: "*******",
                    outerLabel: "Password",
                    obscure: true,
                    filled: true),
                SizedBox(
                  height: 24.h,
                ),
                Center(
                  child: Text(
                    "Or",
                    style: AppTextStyle.bodyNormal12
                        .copyWith(color: AppColors.kTextPrimaryColor),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                GestureDetector(
                  onTap: () async {
                    Util.showLoading("Please Wait!");

                    bool check =
                        await Get.find<AuthController>().signInWithGoogle();
                    Util.dismiss();
                    if (check) {
                      Get.offAllNamed(routeAllListServices);
                    }
                  },
                  child: Container(
                    height: 45.h,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: AppColors.kSocialMediaButtonColor,
                        borderRadius: BorderRadius.circular(30.r)),
                    child: SvgPicture.asset(
                      AppAssets.googleIcon,
                      width: 61.w,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Container(
                  height: 45.h,
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.h),
                  decoration: BoxDecoration(
                      color: AppColors.kSocialMediaButtonColor,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: SvgPicture.asset(
                    AppAssets.facebookIcon,
                    width: 82.w,
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                CommonButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Util.showLoading("Creating Your Account!");
                        bool check = await Get.find<AuthController>()
                            .registerWithEmailAndPassword(
                          userModel: UserModel(
                              email: signUpModel.email,
                              language: signUpModel.language,
                              phone: signUpModel.phone),
                          password: signUpModel.password,
                        ) as bool;
                        Util.dismiss();
                        if (check) {
                          log("DONE");
                          Get.offAllNamed(routeAllListServices);
                        }
                      }
                    },
                    text: "Sign up",
                    isItalicText: false,
                    width: double.infinity,
                    isFilled: true,
                    hasIcon: false),
                SizedBox(
                  height: 36.h,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyle.bodyNormal12.copyWith(
                          color: AppColors.kTextPrimaryColor,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'login',
                            style: AppTextStyle.bodyNormal12.copyWith(
                                decoration: TextDecoration.underline,
                                color: AppColors.kMainColor,
                                fontWeight: FontWeight.w400),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(routeLogin);
                              })
                      ]),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
