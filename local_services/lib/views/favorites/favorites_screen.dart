// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_button.dart';
import 'package:local_services/components/common_user_services_widget.dart';
import 'package:local_services/components/shimmers/service_shimmers.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/controllers/favorites_controller.dart';
import 'package:local_services/controllers/services_controller.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';

class FavoriteServices extends StatefulWidget {
  const FavoriteServices({super.key});

  @override
  State<FavoriteServices> createState() => _FavoriteServicesState();
}

class _FavoriteServicesState extends State<FavoriteServices> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Get.find<FavoritesController>().loadPage(true);
      await Get.find<FavoritesController>().getAllFavorite();
      Get.find<FavoritesController>().loadPage(false);
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
        child: GetBuilder<FavoritesController>(builder: (favoritesController) {
          return favoritesController.isLoading.value == true
              ? ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return const ServiceShimmer();
                  })
              : favoritesController.favoriteServices.isEmpty
                  ? const Center(
                      child: Text("You Don't Have Any Favorites"),
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
                                    favoritesController.favoriteServices.length,
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      bool status = await checkLoginStatus();
                                      if (status == true) {
                                        Util.showServiceDetails(
                                            context,
                                            favoritesController
                                                .favoriteServices[index]);
                                      } else {
                                        Util.showLoginRequiredPopup(context,
                                            () {
                                          Get.toNamed(routeLogin);
                                        });
                                      }
                                    },
                                    child: CommonUserServicesWidget(
                                      onEditTap: () {
                                        Util.showEditService(
                                            context,
                                            favoritesController
                                                .favoriteServices[index]);
                                      },
                                      isServiceByMe: false,
                                      description: favoritesController
                                              .favoriteServices[index]
                                              .description ??
                                          "",
                                      title: favoritesController
                                              .favoriteServices[index].title ??
                                          "",
                                      phone: favoritesController
                                              .favoriteServices[index].phone ??
                                          "",
                                      imgUrl: favoritesController
                                              .favoriteServices[index]
                                              .serviceImageUrl ??
                                          '',
                                    ),
                                  );
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
    );
  }
}
