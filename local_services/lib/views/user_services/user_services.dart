import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_user_services_widget.dart';
import 'package:local_services/components/shimmers/service_shimmers.dart';
import 'package:local_services/controllers/services_controller.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/utils/utils.dart';

class UserServices extends StatefulWidget {
  const UserServices({super.key});

  @override
  State<UserServices> createState() => _UserServicesState();
}

class _UserServicesState extends State<UserServices> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Get.find<ServiceController>().loadPage(true);
      await Get.find<ServiceController>().getServicesById();
      Get.find<ServiceController>().loadPage(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: commonAppBar(
        displayLogo: true,
        context: context,
      ),
      body: SafeArea(
        child: GetBuilder<ServiceController>(builder: (serviceController) {
          return serviceController.isLoading.value == true
              ? ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return const ServiceShimmer();
                  })
              : serviceController.servicesByMeList.isEmpty
                  ? Center(
                      child: Text("you_didn't_upload_any_service".tr),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: ListView.builder(
                                itemCount:
                                    serviceController.servicesByMeList.length,
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  return Slidable(
                                      // The end action pane is the one at the right or the bottom side.
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (_) {
                                              Util.showDeleteService(context,
                                                  () async {
                                                Util.showLoading(
                                                    "deleting...".tr);
                                                bool data = await serviceController
                                                    .deleteServieById(
                                                        serviceId: serviceController
                                                                .servicesByMeList[
                                                                    index]
                                                                .serviceId ??
                                                            "");
                                                if (data == true) {
                                                  Util.dismiss();
                                                  Get.back();
                                                  serviceController
                                                      .loadPage(true);
                                                  await serviceController
                                                      .getServicesById();
                                                  serviceController
                                                      .loadPage(false);
                                                } else {
                                                  Util.dismiss();
                                                  Util.showErrorSnackBar(
                                                      "error_while_deleting_service"
                                                          .tr);
                                                }
                                              });
                                            },
                                            backgroundColor:
                                                AppColors.kPinkColor,
                                            foregroundColor: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            icon: Icons.delete,
                                            label: 'delete'.tr,
                                          ),
                                        ],
                                      ),
                                      child: CommonUserServicesWidget(
                                        onEditTap: () {
                                          Util.showEditService(
                                              context,
                                              serviceController
                                                  .servicesByMeList[index]);
                                        },
                                        isServiceByMe: true,
                                        description: serviceController
                                                .servicesByMeList[index]
                                                .description ??
                                            "",
                                        title: serviceController
                                                .servicesByMeList[index]
                                                .title ??
                                            "",
                                        phone: serviceController
                                                .servicesByMeList[index]
                                                .phone ??
                                            "",
                                        imgUrl: serviceController
                                                .servicesByMeList[index]
                                                .serviceImageUrl ??
                                            '',
                                      ));
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    );
        }),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 20.h, right: 10.w, left: 40.w),
        child: CommonButton(
            width: double.infinity,
            onTap: () {
              Util.showAddService(context);
            },
            text: "add_new_service".tr,
            isItalicText: false,
            isFilled: true,
            hasIcon: false),
      ),
    );
  }
}
