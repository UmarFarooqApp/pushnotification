// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';

class CommonButton extends StatelessWidget {
  final String text;
  double? height;
  double? width;
  Color? fillColor;
  final bool isItalicText;
  final void Function() onTap;
  final bool isFilled;
  final bool hasIcon;
  String? icon;
  Color? iconColor;
  TextStyle? textStyle;
  Color? borderColor;
  double? padding;

  CommonButton(
      {super.key,
      this.height,
      required this.onTap,
      required this.text,
      this.fillColor,
      required this.isItalicText,
      required this.isFilled,
      required this.hasIcon,
      this.iconColor,
      this.icon,
      this.textStyle,
      this.borderColor,
      this.padding,
      this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding ?? 0.w),
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? height ?? 50.h
            : height ?? 80.h,
        width: width ?? 311.w,
        decoration: BoxDecoration(
            color: fillColor ?? AppColors.kMainColor,
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 30.r
                    : 45.r),
            border: Border.all(
                width: borderColor != null ? 1 : 0,
                color:
                    borderColor != null ? borderColor! : Colors.transparent)),
        child: Center(
          child: hasIcon
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      icon ?? AppAssets.backButtonIcon,
                      color: iconColor ?? AppColors.kTextPrimaryColor,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      text,
                      style: AppTextStyle.bodySemiBold16.copyWith(
                        fontStyle:
                            isItalicText ? FontStyle.italic : FontStyle.normal,
                        fontSize: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 16.sp
                            : 12.sp,
                        color: isFilled
                            ? AppColors.kWhiteColor
                            : AppColors.kTextPrimaryColor,
                      ),
                    )
                  ],
                )
              : Text(
                  text,
                  style: textStyle ??
                      AppTextStyle.bodySemiBold16.copyWith(
                          fontStyle: isItalicText
                              ? FontStyle.italic
                              : FontStyle.normal,
                          fontSize: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 16.sp
                              : 12.sp,
                          color: isFilled
                              ? AppColors.kWhiteColor
                              : AppColors.kTextPrimaryColor),
                ),
        ),
      ),
    );
  }
}
