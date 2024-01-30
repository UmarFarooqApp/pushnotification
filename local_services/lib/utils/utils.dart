// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_cache_network_image.dart';
import 'package:local_services/components/common_dropdown.dart';
import 'package:local_services/components/common_textfield.dart';
import 'package:local_services/controllers/categories_controller.dart';
import 'package:local_services/controllers/favorites_controller.dart';
import 'package:local_services/controllers/services_controller.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/model/local/local_service_model.dart';
import 'package:local_services/model/service_model.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:share_plus/share_plus.dart';

class Util {
  static void showLoading(String message) {
    EasyLoading.show(
      status: message,
      indicator: const CircularProgressIndicator.adaptive(
        backgroundColor: AppColors.kWhiteColor,
      ),
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.clear,
    );
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }

  static void setEasyLoading() {
    EasyLoading.instance
      ..textColor = AppColors.kMainColor
      ..indicatorSize = 22.w
      ..indicatorColor = AppColors.kMainColor
      ..indicatorType = EasyLoadingIndicatorType.foldingCube
      ..userInteractions = false
      ..dismissOnTap = false
      ..backgroundColor = AppColors.kWhiteColor
      ..animationStyle = EasyLoadingAnimationStyle.opacity
      ..animationDuration = const Duration(milliseconds: 400);
  }

  static void showErrorSnackBar(String message) {
    Get.snackbar(
      "",
      "",
      duration: const Duration(milliseconds: 1200),
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(
        message,
        style: AppTextStyle.bodyNormal16.copyWith(color: AppColors.kWhiteColor),
      ),
      messageText: const SizedBox(),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 60.h, left: 16.w, right: 16.w),
      backgroundColor: AppColors.kMainColor,
    );
  }

  static void showDeleteService(BuildContext context, Function() onPressed) {
    showDialog(
      context: context,
      barrierColor: AppColors.kBlackColor.withOpacity(0.80),
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          title: Text(
            'Delete Service',
            style: AppTextStyle.bodyBold24.copyWith(
              color: AppColors.kBlackColor,
              fontSize:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? 24.sp
                      : 16.sp,
            ),
          ),
          content: Text(
            "Are you Sure You Want To Delete?",
            style: AppTextStyle.bodyNormal16
                .copyWith(color: AppColors.kBlackColor),
          ),
          actions: [
            TextButton(
              child: Text(
                'No',
                style: AppTextStyle.bodyNormal16
                    .copyWith(color: AppColors.kBlackColor),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
                onPressed: onPressed,
                child: Text(
                  'Yes',
                  style: AppTextStyle.bodyNormal16.copyWith(
                      color: AppColors.kMainColor, fontWeight: FontWeight.w700),
                ))
          ],
        );
      },
    );
  }

  static void showLoginRequiredPopup(
      BuildContext context, Function() onPressed) {
    showDialog(
      context: context,
      barrierColor: AppColors.kBlackColor.withOpacity(0.80),
      builder: (context) {
        return Container(
          height: 200.h,
          child: AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            title: Center(
              child: Text(
                'Login Required',
                style: AppTextStyle.bodyNormal16.copyWith(
                  color: AppColors.kTextSecondaryColor,
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 16.sp
                          : 12.sp,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Login is required for complete access to this application,Please login",
                  style: AppTextStyle.bodyNormal14
                      .copyWith(color: AppColors.kTextPrimaryColor),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        onTap: () {
                          Get.back();
                        },
                        text: "Cancel",
                        isItalicText: false,
                        isFilled: true,
                        fillColor: AppColors.kCancelButtonColor,
                        hasIcon: false,
                        borderColor: AppColors.kCancelButtonColor,
                        textStyle: AppTextStyle.bodySemiBold16.copyWith(
                            fontSize: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 16.sp
                                : 12.sp,
                            color: AppColors.kMainColor),
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: CommonButton(
                        onTap: onPressed,
                        text: "Login",
                        isItalicText: false,
                        isFilled: true,
                        fillColor: AppColors.kMainColor,
                        hasIcon: false,
                      ),
                    )
                  ],
                ),
              ],
            ),
            // actions: [

            //   TextButton(
            //     child: Text(
            //       'No',
            //       style: AppTextStyle.bodyNormal16
            //           .copyWith(color: AppColors.kBlackColor),
            //     ),
            //     onPressed: () {
            //       Get.back();
            //     },
            //   ),
            //   TextButton(
            //       onPressed: onPressed,
            //       child: Text(
            //         'Yes',
            //         style: AppTextStyle.bodyNormal16.copyWith(
            //             color: AppColors.kMainColor, fontWeight: FontWeight.w700),
            //       ))
            // ],
          ),
        );
      },
    );
  }

  static void showAddService(BuildContext context) {
    var uploadimage;
    final _formKey = GlobalKey<FormState>();
    LocalServiceModel localServiceModel = LocalServiceModel(
        title: "",
        category: "",
        description: "",
        phone: "",
        imgUrl: "",
        latitude: "",
        cityName: "",
        longitude: "",
        searchList: <String>[]);
    Future<XFile?> chooseImage() async {
      XFile? choosedimage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      // await Permission.photos.request();
      // var permissionStatus = await Permission.photos.status;

      // if (permissionStatus.isGranted) {
      //   choosedimage =
      //       await ImagePicker().pickImage(source: ImageSource.gallery);
      // } else {
      //   showErrorSnackBar("Please allow gallery permissions");
      // }
      return choosedimage;
    }

    showDialog(
      barrierColor: AppColors.kBlackColor.withOpacity(0.80),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            content: SizedBox(
              width: 360.w,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          "add_new_service".tr,
                          style: AppTextStyle.bodyNormal16
                              .copyWith(color: AppColors.kTextSecondaryColor),
                        ),
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.title = e.toString();
                        },
                        validator: (e) {
                          if (e.toString().isEmpty) {
                            return "title_cant_be_empty".tr;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (e) {
                          localServiceModel.searchList.add(e.toString());
                        },
                        filled: true,
                        outerLabelColor: AppColors.kMainColor,
                        outerLabel: 'title'.tr,
                        hintText: "title".tr,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonDropdownButton(
                        items: Get.find<CategoriesController>().allCategories,
                        label: 'categories'.tr,
                        showOffset: false,
                        labelColor: AppColors.kMainColor,
                        onSaved: (e) {
                          localServiceModel.category =
                              e.toString().toLowerCase();
                        },
                        onChange: (e) {
                          localServiceModel.category =
                              e.toString().toLowerCase();
                        },
                        hintText: "select_a_category".tr,
                        showBorder: true,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.description = e.toString();
                        },
                        validator: (e) {
                          if (e.toString().isEmpty) {
                            return "description_cant_be_empty".tr;
                          } else {
                            return null;
                          }
                        },
                        filled: true,
                        maxLines: 4,
                        outerLabelColor: AppColors.kMainColor,
                        outerLabel: 'description'.tr,
                        hintText: "description".tr,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.phone = e.toString();
                        },
                        validator: (e) {
                          return phoneValidator(
                              e, "enter_a_valid_phone_number".tr);
                        },
                        filled: true,
                        outerLabelColor: AppColors.kMainColor,
                        inputType: TextInputType.number,
                        outerLabel: 'enter_phone_number'.tr,
                        hintText: "phone_number".tr,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.cityName = e.toString();
                        },
                        validator: (e) {
                          if (e.toString().isEmpty) {
                            return "City Name Can't Be Empty";
                          } else {
                            return null;
                          }
                        },
                        filled: true,
                        outerLabelColor: AppColors.kMainColor,
                        outerLabel: 'City Name',
                        hintText: "City Name",
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      uploadimage == null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Choose Image",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                    color: AppColors.kTextPrimaryColor),
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Selected Image",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                    color: AppColors.kTextPrimaryColor),
                              ),
                            ),
                      SizedBox(
                        height: 8.h,
                      ),
                      uploadimage == null
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    XFile? path = await chooseImage();
                                    if (path != null) {
                                      setState(() {
                                        uploadimage = File(path.path);
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                        color: AppColors.kWhiteColor,
                                        border: Border.all(
                                            color: Color(0xFF6E7D86),
                                            width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(2.r)),
                                    child: Text(
                                      'Choose File',
                                      style: AppTextStyle.bodyNormal14.copyWith(
                                        color:
                                            Color(0xFF324754).withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer()
                              ],
                            )
                          : Container(
                              height: 200.h,
                              width: 360.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.file(uploadimage))),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (uploadimage == null) {
                                Util.showErrorSnackBar(
                                    "Please Upload An Image");
                              } else {
                                bool returnValue =
                                    await Get.find<ServiceController>()
                                        .addServicesToFirebase(
                                  serviceModel: ServiceModel(
                                      searchList: localServiceModel.searchList,
                                      title: localServiceModel.title,
                                      description:
                                          localServiceModel.description,
                                      phone: localServiceModel.phone,
                                      category: localServiceModel.category,
                                      cityName: localServiceModel.cityName),
                                  imageUrl: uploadimage,
                                );
                                if (returnValue == true) {
                                  Get.back();
                                  Util.dismiss();
                                  Util.showErrorSnackBar("Service Uploaded");
                                  Get.find<ServiceController>()
                                      .getServicesById();
                                } else {
                                  Get.back();
                                }
                              }
                            }
                          },
                          text: "Save",
                          isItalicText: false,
                          isFilled: true,
                          hasIcon: false)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static void showEditService(BuildContext context, ServiceModel serviceModel) {
    var uploadimage;
    final _formKey = GlobalKey<FormState>();
    LocalServiceModel localServiceModel = LocalServiceModel(
        title: "",
        category: "",
        description: "",
        phone: "",
        imgUrl: "",
        latitude: "",
        cityName: "",
        longitude: "",
        searchList: <String>[]);
    Future<XFile?> chooseImage() async {
      XFile? choosedimage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      // await Permission.photos.request();
      // var permissionStatus;
      // if (Platform.isAndroid) {
      //   final androidInfo = await DeviceInfoPlugin().androidInfo;
      //   if (androidInfo.version.sdkInt <= 32) {
      //     permissionStatus = await Permission.storage.status;
      //   } else {
      //     permissionStatus = await Permission.photos.status;
      //   }
      // }

      // if (permissionStatus.isGranted) {

      // } else {
      //   showErrorSnackBar("Please allow gallery permissions");
      // }
      return choosedimage;
    }

    showDialog(
      barrierColor: AppColors.kBlackColor.withOpacity(0.80),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            content: Container(
              width: 360.w,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          "Add New Service",
                          style: AppTextStyle.bodyNormal16
                              .copyWith(color: AppColors.kTextSecondaryColor),
                        ),
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.title = e.toString();
                        },
                        initialText: serviceModel.title,
                        validator: (e) {
                          if (e.toString().isEmpty) {
                            return "Title Can't Be Empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (e) {
                          localServiceModel.searchList.add(e.toString());
                        },
                        filled: true,
                        outerLabelColor: AppColors.kMainColor,
                        outerLabel: 'Title',
                        hintText: "Title",
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonDropdownButton(
                        items: Get.find<CategoriesController>().allCategories,
                        label: 'Categories',
                        showOffset: false,
                        labelColor: AppColors.kMainColor,
                        onSaved: (e) {
                          localServiceModel.category =
                              e.toString().toLowerCase();
                        },
                        onChange: (e) {
                          localServiceModel.category =
                              e.toString().toLowerCase();
                        },
                        hintText: "Select A Category",
                        showBorder: true,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.description = e.toString();
                        },
                        validator: (e) {
                          if (e.toString().isEmpty) {
                            return "Description Can't Be Empty";
                          } else {
                            return null;
                          }
                        },
                        filled: true,
                        maxLines: 4,
                        initialText: serviceModel.description,
                        outerLabelColor: AppColors.kMainColor,
                        outerLabel: 'Description',
                        hintText: "Description",
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.phone = e.toString();
                        },
                        validator: (e) {
                          return phoneValidator(
                              e, "Enter A Valid Phone Number");
                        },
                        filled: true,
                        initialText: serviceModel.phone,
                        outerLabelColor: AppColors.kMainColor,
                        inputType: TextInputType.number,
                        outerLabel: 'Enter Phone Number',
                        hintText: "Phone Number",
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonTextFieldNew(
                        onSaved: (e) {
                          localServiceModel.cityName = e.toString();
                        },
                        validator: (e) {
                          if (e.toString().isEmpty) {
                            return "City Name Can't Be Empty";
                          } else {
                            return null;
                          }
                        },
                        filled: true,
                        initialText: serviceModel.cityName,
                        outerLabelColor: AppColors.kMainColor,
                        outerLabel: 'City Name',
                        hintText: "City Name",
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      uploadimage == null
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Choose Image",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                    color: AppColors.kTextPrimaryColor),
                              ),
                            )
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Selected Image",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                    color: AppColors.kTextPrimaryColor),
                              ),
                            ),
                      SizedBox(
                        height: 8.h,
                      ),
                      uploadimage == null
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    XFile? path = await chooseImage();
                                    if (path != null) {
                                      setState(() {
                                        uploadimage = File(path.path);
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                        color: AppColors.kWhiteColor,
                                        border: Border.all(
                                            color: Color(0xFF6E7D86),
                                            width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(2.r)),
                                    child: Text(
                                      'Choose File',
                                      style: AppTextStyle.bodyNormal14.copyWith(
                                        color:
                                            Color(0xFF324754).withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer()
                              ],
                            )
                          : Container(
                              height: 200.h,
                              width: 360.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.file(uploadimage))),
                      SizedBox(
                        height: 16.h,
                      ),
                      CommonButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              FocusManager.instance.primaryFocus?.unfocus();
                              Util.showLoading("Updating Service...");
                              bool returnValue = await Get.find<
                                      ServiceController>()
                                  .updateService(
                                      serviceModel: ServiceModel(
                                          searchList:
                                              localServiceModel.searchList,
                                          title: localServiceModel.title,
                                          description:
                                              localServiceModel.description,
                                          phone: localServiceModel.phone,
                                          serviceImageUrl:
                                              serviceModel.serviceImageUrl,
                                          category:
                                              localServiceModel.category == ""
                                                  ? serviceModel.category
                                                  : localServiceModel.category,
                                          cityName: localServiceModel.cityName),
                                      imageUrl: uploadimage,
                                      serviceId: serviceModel.serviceId ?? '');
                              if (returnValue == true) {
                                Get.back();

                                Util.dismiss();
                                Util.showErrorSnackBar("Serice Updated");

                                Get.find<ServiceController>().getServicesById();
                              } else {
                                Get.back();

                                Util.dismiss();
                              }
                            }
                          },
                          text: "Update",
                          isItalicText: false,
                          isFilled: true,
                          hasIcon: false)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static void showServiceDetails(
      BuildContext context, ServiceModel serviceModel) {
    showDialog(
      barrierColor: AppColors.kBlackColor.withOpacity(0.80),
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
            content: Container(
              width: 360.w,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 360.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.kMainColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceModel.title ?? "",
                            style: AppTextStyle.bodySemiBold20.copyWith(
                                color: AppColors.kPopupHeadingTextColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            serviceModel.cityName ?? "",
                            style: AppTextStyle.bodyNormal12.copyWith(
                                color: AppColors.kPopupSubHeadingTextColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CustomCachedNetworkImage(
                          imgUrl: serviceModel.serviceImageUrl ?? "",
                          height: 134.h,
                          width: 327.w,
                          errorImg: AppAssets.logo2Image),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launchWhatsApp(
                                int.parse(serviceModel.phone.toString()));
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssets.waLogoImage,
                                height: 14.h,
                                width: 14.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "WhatsApp",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                    color: AppColors.kTextPrimaryColor),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            launchPhone(serviceModel.phone.toString());
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.callIcon,
                                height: 14.h,
                                width: 14.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Call",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                    color: AppColors.kTextPrimaryColor),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (Get.find<FavoritesController>()
                                .serviceFavoriteList
                                .contains(serviceModel.serviceId)) {
                              Get.back();
                              Util.showLoading("Removing From Favorite...");
                              Get.find<FavoritesController>()
                                  .removeFromFavorite(
                                      serviceModel.serviceId ?? "");
                              Util.dismiss();
                              Util.showErrorSnackBar(
                                  "Service Removed From Favorites");
                              // Get.find<FavoritesController>().getAllFavorite();
                            } else {
                              Get.back();
                              Util.showLoading("Adding To Favorite...");
                              Get.find<FavoritesController>()
                                  .addToFavorite(serviceModel.serviceId ?? "");
                              Util.dismiss();
                              Util.showErrorSnackBar(
                                  "Service Added In Favorites");
                              // Get.find<FavoritesController>().getAllFavorite();
                            }
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.favoriteIcon,
                                color: Get.find<FavoritesController>()
                                        .serviceFavoriteList
                                        .contains(serviceModel.serviceId)
                                    ? AppColors.kMainColor
                                    : AppColors.kTextPrimaryColor,
                                height: 14.h,
                                width: 14.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Favorite",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                  color: Get.find<FavoritesController>()
                                          .serviceFavoriteList
                                          .contains(serviceModel.serviceId)
                                      ? AppColors.kMainColor
                                      : AppColors.kTextPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Share.share('Check out this service!');
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.shareIcon,
                                height: 14.h,
                                width: 14.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Share",
                                style: AppTextStyle.bodyNormal12.copyWith(
                                    color: AppColors.kTextPrimaryColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Container(
                      height: 2.w,
                      width: 327.w,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                            AppColors.kWhiteColor,
                            AppColors.kTextPrimaryColor,
                            AppColors.kWhiteColor
                          ])),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        serviceModel.description ?? "",
                        textAlign: TextAlign.start,
                        style: AppTextStyle.bodyNormal22
                            .copyWith(color: AppColors.kTextPrimaryColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  static bool checkFirebaseException(String e) {
    if (e == 'invalid-email') {
      Util.showErrorSnackBar("Invalid Email");
      return true;
    } else if (e == 'user-disabled') {
      Util.showErrorSnackBar("User Disabled");
      return true;
    } else if (e == 'user-not-found') {
      Util.showErrorSnackBar("User Not Found");
      return true;
    } else if (e == 'wrong-password') {
      Util.showErrorSnackBar("Wrong Password");
      return true;
    } else if (e == 'weak-password') {
      Util.showErrorSnackBar("Week Password");
      return true;
    } else if (e == 'operation-not-allowed') {
      Util.showErrorSnackBar("This Operation Is Not Allowed");
      return true;
    } else if (e == 'email-already-in-use') {
      Util.showErrorSnackBar("Email Already Exists");
      return true;
    } else if (e == "too-many-requests") {
      Util.showErrorSnackBar("Too Many Requests");
      return true;
    } else if (e == "requires-recent-login") {
      Util.showErrorSnackBar("Requires Recent Login");
      return true;
    }
    return false;
  }
}
