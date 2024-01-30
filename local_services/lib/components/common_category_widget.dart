import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';

class CommonCategoryWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function() onTap;
  const CommonCategoryWidget({
    required this.isSelected,
    required this.onTap,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.w),
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            color: isSelected ? AppColors.kMainColor : AppColors.kWhiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.kCategoryShadowColor.withOpacity(0.20),
                  spreadRadius: 1,
                  blurRadius: 5)
            ],
            border: Border.all(color: AppColors.kMainColor)),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.bodyNormal12.copyWith(
                color:
                    isSelected ? AppColors.kWhiteColor : AppColors.kMainColor),
          ),
        ),
      ),
    );
  }
}
