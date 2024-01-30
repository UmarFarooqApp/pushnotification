// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_cache_network_image.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';

class CommonUserServicesWidget extends StatelessWidget {
  final String description;
  final String title;
  final String phone;
  final String imgUrl;
  final bool isServiceByMe;
  void Function()? onEditTap;
  CommonUserServicesWidget({
    required this.description,
    required this.title,
    required this.phone,
    required this.imgUrl,
    this.onEditTap,
    required this.isServiceByMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppColors.kSocialMediaButtonColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(4.r),
                //   child: Image.asset(
                //     AppAssets.testImage,
                //     height: 105.h,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: CustomCachedNetworkImage(
                    imgUrl: imgUrl,
                    height: 105.h,
                    width: 140.w,
                    errorImg: AppAssets.logoImage,
                    borderRadius: 4.r,
                  ),
                ),
                isServiceByMe
                    ? Positioned(
                        right: 5.w,
                        top: 5.w,
                        child: GestureDetector(
                          onTap: onEditTap,
                          child: SvgPicture.asset(
                            AppAssets.editIcon,
                            height: 16.h,
                            width: 16.w,
                            color: AppColors.kPinkColor,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 105.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bodyNormal16.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.kTextSecondaryColor),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    description,
                    style: AppTextStyle.bodyNormal12.copyWith(
                        fontWeight: FontWeight.w300,
                        color: AppColors.kTextPrimaryColor),
                  ),
                  const Spacer(),
                  isServiceByMe
                      ? Row(
                          children: [
                            Image.asset(
                              AppAssets.waLogoImage,
                              width: 14.w,
                              height: 14.h,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              phone,
                              style: AppTextStyle.bodyNormal12.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.kMainColor),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                bool status = await checkLoginStatus();
                                if (status == true) {
                                  launchWhatsApp(int.parse(phone));
                                } else {
                                  Util.showLoginRequiredPopup(context, () {
                                    Get.toNamed(routeLogin);
                                  });
                                }
                              },
                              child: Container(
                                color: AppColors.kSocialMediaButtonColor,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 15.h,
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                          color: AppColors.kWhatsAppBoxColor,
                                          borderRadius:
                                              BorderRadius.circular(1.r)),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Image.asset(
                                      AppAssets.waLogoImage,
                                      height: 14.h,
                                      width: 14.w,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Container(
                                      height: 15.h,
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                          color: AppColors.kWhatsAppBoxColor,
                                          borderRadius:
                                              BorderRadius.circular(1.r)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                bool status = await checkLoginStatus();
                                if (status == true) {
                                  launchPhone(phone);
                                } else {
                                  Util.showLoginRequiredPopup(context, () {
                                    Get.toNamed(routeLogin);
                                  });
                                }
                              },
                              child: Container(
                                color: AppColors.kSocialMediaButtonColor,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 15.h,
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                          color: AppColors.kCallBoxColor,
                                          borderRadius:
                                              BorderRadius.circular(1.r)),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    SvgPicture.asset(
                                      AppAssets.callIcon,
                                      height: 14.h,
                                      width: 14.w,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Container(
                                      height: 15.h,
                                      width: 18.w,
                                      decoration: BoxDecoration(
                                          color: AppColors.kCallBoxColor,
                                          borderRadius:
                                              BorderRadius.circular(1.r)),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
