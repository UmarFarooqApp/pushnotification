import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: commonAppBar(context: context, displayLogo: true),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 12.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Lorem ipsum dolor sit amet consectetur. Molestie dolor habitasse neque libero leo egestas sit. Viverra convallis condimentum velit tellus mattis ornare phasellus. A sapien ut iaculis sed elit et vel. In tincidunt sem ultricies ac varius id tellus porta id. Semper massa feugiat elementum amet in id odio. Ut id ante fames id sed. Massa sem convallis ut leo tincidunt mauris. Vel vitae morbi dignissim turpis.",
                style: AppTextStyle.bodyNormal12.copyWith(
                  color: AppColors.kTextPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
