import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
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
// import 'package:permission_handler/permission_handler.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  SignUpModel signUpModel =
      SignUpModel(email: "", password: "", phone: "", language: "");
  final _formKey = GlobalKey<FormState>();
  var uploadimage; //variable for choosed file

  Future<void> chooseImage() async {
    // await Permission.photos.request();

    // var permissionStatus = await Permission.photos.status;

    //set source: ImageSource.camera to get image from camera
    XFile? choosedimage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (permissionStatus.isGranted) {
    setState(() {
      uploadimage = File(choosedimage!.path);
    });
    // }

    log(uploadimage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: AppColors.kWhiteColor,
        appBar: commonAppBar(
          displayLogo: true,
          context: context,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 34.h,
                  ),
                  Center(
                    child: Text(
                      "upload_photo".tr,
                      style: AppTextStyle.bodyNormal12
                          .copyWith(color: AppColors.kTextPrimaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      chooseImage();
                    },
                    child: uploadimage == null
                        ? CircleAvatar(
                            radius: 51.r,
                            backgroundColor: AppColors.kTextPrimaryColor,
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundColor: AppColors.kWhiteColor,
                              child: SvgPicture.asset(
                                AppAssets.cameraIcon,
                                color: AppColors.kTextPrimaryColor,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 51.r,
                            backgroundColor: AppColors.kTextPrimaryColor,
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: FileImage(uploadimage),
                            ),
                          ),
                  ),
                  // CommonTextFieldNew(
                  //     onSaved: (e) {},
                  //     validator: (e) {
                  //       return null;
                  //     },
                  //     initialText: authController.user.value.name,
                  //     outerLabel: "Name",
                  //     enabled: true,
                  //     filled: true),
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  CommonTextFieldNew(
                      onSaved: (e) {
                        signUpModel.phone = e.toString();
                      },
                      validator: (e) {
                        return phoneValidator(e, "enter_a_valid_phone".tr);
                      },
                      initialText: authController.user.value?.phone,
                      outerLabel: "phone_number".tr,
                      enabled: true,
                      filled: true),
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  // CommonTextFieldNew(
                  //     onSaved: (e) {},
                  //     validator: (e) {
                  //       return null;
                  //     },
                  //     initialText: "ABC Town",
                  //     outerLabel: "Address",
                  //     enabled: true,
                  //     filled: true),
                  const Spacer(),
                  CommonButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          FocusManager.instance.primaryFocus?.unfocus();

                          Util.showLoading("updating_your_profile".tr);

                          bool check = await Get.find<AuthController>()
                              .updateUserAccount(
                                  userModel:
                                      UserModel(phone: signUpModel.phone),
                                  profileUrl: uploadimage) as bool;
                          Util.dismiss();
                          if (check) {
                            Get.offAllNamed(routeProfileHome);
                          }
                        }
                      },
                      text: "save".tr,
                      isItalicText: false,
                      isFilled: true,
                      width: double.infinity,
                      hasIcon: false),
                  SizedBox(
                    height: 60.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
