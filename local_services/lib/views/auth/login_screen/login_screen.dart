import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_textfield.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/controllers/auth_controller.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/model/local/login_model.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  LoginModel loginModel = LoginModel(email: "", password: "");
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
                      loginModel.email = e.toString();
                    },
                    validator: (e) {
                      return emailValidator(e, "Enter A Valid Email");
                    },
                    hintText: "Email Address",
                    outerLabel: "Enter Email Address",
                    filled: true),
                SizedBox(
                  height: 16.h,
                ),
                CommonTextFieldNew(
                    onSaved: (e) {
                      loginModel.password = e.toString();
                    },
                    validator: (e) {
                      return passwordValidator(e, "Enter A Valid Password");
                    },
                    hintText: "*******",
                    outerLabel: "Password",
                    obscure: true,
                    filled: true),
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(routeForgotPassword);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password",
                      style: AppTextStyle.bodyNormal12
                          .copyWith(color: AppColors.kMainColor),
                    ),
                  ),
                ),
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
                GestureDetector(
                  onTap: () {},
                  child: Container(
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
                ),
                SizedBox(
                  height: 38.h,
                ),
                CommonButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Util.showLoading("Loading");
                        bool temp = await Get.find<AuthController>()
                            .signInWithEmailAndPassword(
                          loginModel.email,
                          loginModel.password,
                        );
                        Util.dismiss();
                        if (temp) {
                          Get.offAllNamed(routeAllListServices);
                          Util.showErrorSnackBar(
                            "Logged In",
                          );
                        }
                      }
                    },
                    text: 'sign_in'.tr,
                    isItalicText: false,
                    width: double.infinity,
                    isFilled: true,
                    hasIcon: false),
                SizedBox(
                  height: 36.h,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Don’t have an account ',
                      style: AppTextStyle.bodyNormal12.copyWith(
                          color: AppColors.kTextPrimaryColor,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Sign up',
                            style: AppTextStyle.bodyNormal12.copyWith(
                                decoration: TextDecoration.underline,
                                color: AppColors.kMainColor,
                                fontWeight: FontWeight.w400),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(routeRegister);
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
