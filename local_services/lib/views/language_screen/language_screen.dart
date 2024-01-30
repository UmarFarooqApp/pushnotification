import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_dropdown.dart';
import 'package:local_services/controllers/auth_controller.dart';
import 'package:local_services/controllers/language_controller.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/utils/utils.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLanguage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: commonAppBar(
        displayLogo: true,
        context: context,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              CommonDropdownButton(
                  items: const ["English", "Arabic", "French"],
                  onSaved: (e) {},
                  showBorder: true,
                  showOffset: false,
                  hintText: "Select Language",
                  label: "Change Language",
                  onChange: (e) {
                    selectedLanguage = e.toString().toLowerCase();
                  }),
              const Spacer(),
              CommonButton(
                  onTap: () async {
                    if (selectedLanguage == "") {
                      Util.showErrorSnackBar("Please Select A Language");
                    } else {
                      Util.showLoading("Updating Language...");
                      bool data = await Get.find<AuthController>()
                          .updateUserLanguage(selectedLanguage);
                      Get.find<LanguageController>()
                          .updateLanguage(selectedLanguage.toString());
                      if (data == true) {
                        Util.dismiss();
                        Util.showErrorSnackBar("Language Updated!");
                      } else {
                        Util.dismiss();
                        Util.showErrorSnackBar("Error In Updating Language");
                      }
                    }
                  },
                  text: "Save",
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
    );
  }
}
