import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';

PreferredSizeWidget commonAppBar({
  String? title,
  bool showBackButton = true,
  VoidCallback? onLeadingTap,
  bool? centerTitle = true,
  Widget? leadingWidget,
  double? titleSpacing,
  EdgeInsetsGeometry? showButtonPadding,
  TextStyle? textStyle,
  PreferredSizeWidget? bottom,
  BuildContext? context,
  GlobalKey<ScaffoldState>? scaffoldKey,
  List<Widget>? actions,
  bool? displayLogo,
  // required void Function() onTap,
}) {
  return AppBar(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: AppColors.kMainColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
    toolbarHeight: MediaQuery.of(context!).orientation == Orientation.portrait
        ? 60.h
        : 100.h,
    elevation: 0,
    centerTitle: centerTitle,
    backgroundColor: AppColors.kWhiteColor,
    titleSpacing: titleSpacing ?? 0,
    title: displayLogo == true
        ? Image.asset(
            AppAssets.logo2Image,
            width: 108.w,
          )
        : (title != null)
            ? Text(
                title,
                style: textStyle ??
                    AppTextStyle.bodySemiBold20.copyWith(
                      color: AppColors.kWhiteColor,
                      fontSize: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 20.sp
                          : 12.sp,
                    ),
              )
            : null,
    automaticallyImplyLeading: false,
    leading: showBackButton
        ? Padding(
            padding: showButtonPadding ??
                EdgeInsets.only(
                  left: 0.w,
                ),
            child: IconButton(
              onPressed: onLeadingTap ??
                  () {
                    Get.back();
                  },
              splashRadius: 24.h,
              icon: SvgPicture.asset(
                AppAssets.backButtonIcon,
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 20.h
                        : 32.h,
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 20.h
                        : 32.h,
              ),
            ),
          )
        : leadingWidget,
    actions: actions,
    bottom: bottom,
  );
}
