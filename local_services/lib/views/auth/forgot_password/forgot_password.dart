import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_textfield.dart';
import 'package:local_services/controllers/auth_controller.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(showBackButton: true, context: context),
      backgroundColor: AppColors.kWhiteColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
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
                    email = e.toString();
                  },
                  validator: (e) {
                    return emailValidator(e, "Enter A Valid Email");
                  },
                  hintText: "Email Address",
                  outerLabel: "Enter Email Address",
                  filled: true),
              const Spacer(),
              CommonButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Util.showLoading("Sending Link");
                      await Get.find<AuthController>()
                          .resetPasword(email: email);
                      Util.dismiss();
                    }
                  },
                  text: "Reset Password",
                  isItalicText: false,
                  width: double.infinity,
                  isFilled: true,
                  hasIcon: false),
              SizedBox(
                height: 80.h,
              ),
            ],
          ),
        ),
      )),
    );
  }
}
