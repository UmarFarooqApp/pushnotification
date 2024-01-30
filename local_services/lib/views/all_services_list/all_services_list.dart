// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_services/components/common_appbar.dart';
import 'package:local_services/components/common_category_widget.dart';
import 'package:local_services/components/common_drawer.dart';
import 'package:local_services/components/common_dropdown.dart';
import 'package:local_services/components/common_textfield.dart';
import 'package:local_services/components/common_user_services_widget.dart';
import 'package:local_services/components/shimmers/service_shimmers.dart';
import 'package:local_services/config/routes.dart';
import 'package:local_services/controllers/all_services_controller.dart';

import 'package:local_services/controllers/categories_controller.dart';
import 'package:local_services/controllers/cities_controller.dart';
import 'package:local_services/controllers/language_controller.dart';
import 'package:local_services/controllers/location_controller.dart';
import 'package:local_services/helpers/app_assets.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/utils/extra_functions.dart';
import 'package:local_services/utils/utils.dart';

class AllServicesList extends StatefulWidget {
  const AllServicesList({super.key});

  @override
  State<AllServicesList> createState() => _AllServicesListState();
}

class _AllServicesListState extends State<AllServicesList> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String viewType = "map";
  String selectedCategory = "";
  String selectedCity = "";
  Completer<GoogleMapController> _controller = Completer();

  late final CameraPosition _kGoogle;
  List<Marker> marker = [];
  late final List<Marker> _list;
  @override
  void initState() {
    _kGoogle = CameraPosition(
      target: LatLng(Get.find<LocationController>().currentPosition.latitude,
          Get.find<LocationController>().currentPosition.longitude),
      zoom: 14.4746,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Get.find<AllServicesController>().loadPage(true);
      await Get.find<AllServicesController>().getAllServices();

      _list = [];
      for (var i = 0;
          i < Get.find<AllServicesController>().allServices.length;
          i++) {
        _list.add(
          Marker(
              markerId: MarkerId(Get.find<AllServicesController>()
                  .allServices[i]
                  .serviceId
                  .toString()),
              onTap: () async {
                bool status = await checkLoginStatus();
                if (status == true) {
                  Util.showServiceDetails(context,
                      Get.find<AllServicesController>().allServices[i]);
                } else {
                  Util.showLoginRequiredPopup(context, () {
                    Get.toNamed(routeLogin);
                  });
                }
              },
              position: LatLng(
                  double.parse(Get.find<AllServicesController>()
                      .allServices[i]
                      .latitude
                      .toString()),
                  double.parse(Get.find<AllServicesController>()
                      .allServices[i]
                      .longitude
                      .toString())),
              infoWindow: InfoWindow(
                title: Get.find<AllServicesController>()
                    .allServices[i]
                    .title
                    .toString(),
              )),
        );
      }
      log(_list.toString());
      marker.addAll(_list);
      Get.find<AllServicesController>().loadPage(false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(builder: (languageController) {
      return GetBuilder<CategoriesController>(builder: (categoriesController) {
        return GetBuilder<AllServicesController>(
            builder: (allServicesController) {
          return Scaffold(
            key: scaffoldKey,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            backgroundColor: AppColors.kWhiteColor,
            drawer: CommonDrawer(
              scaffoldKey: scaffoldKey,
            ),
            appBar: commonAppBar(
              context: context,
              displayLogo: true,
              showBackButton: false,
              leadingWidget: IconButton(
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: SvgPicture.asset(AppAssets.menuIcon, height: 16.h)),
              onLeadingTap: () {
                log("here");
                scaffoldKey.currentState?.openDrawer();
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Container(
                    height: 44.h,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColors.kWhiteColor,
                      border: Border.all(color: AppColors.kMainColor),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16.w,
                        ),
                        SvgPicture.asset(AppAssets.pinIcon),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          // width: 200.w,
                          child: CommonTextFieldNew(
                            onSaved: (e) {},
                            validator: (e) {
                              return null;
                            },
                            onChanged: (e) async {
                              if (e.toString() == "") {
                                allServicesController.loadPage(true);
                                await allServicesController.getAllServices();
                                allServicesController.loadPage(false);
                              } else {
                                allServicesController.loadPage(true);
                                await allServicesController
                                    .searchServices(e.toString());
                                allServicesController.loadPage(false);
                              }
                            },
                            contentPadding: EdgeInsets.only(
                                left: 0.w, top: 14.h, bottom: 10.h),
                            showShadow: false,
                            borderRadius: 50.r,
                            hintText: 'search_for_parking'.tr,
                            disableBorder: true,
                            borderColor: AppColors.kWhiteColor,
                            focusedBorderColor: AppColors.kWhiteColor,
                            filled: true,
                            fillColor: AppColors.kWhiteColor,
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Container(
                          height: 20.h,
                          width: 2.w,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                AppColors.kWhiteColor,
                                AppColors.kTextPrimaryColor,
                                AppColors.kWhiteColor
                              ])),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5.h),
                          height: 40.h,
                          width: 100.w,
                          child: CommonDropdownButton(
                              borderRadius: 60.r,
                              hintText: "city".tr,
                              items: Get.find<CitiesController>().allCities,
                              dropdownHeight: true,
                              showPadding: true,
                              showOffset: true,
                              onSaved: (e) {},
                              showBorder: true,
                              borderColor: AppColors.kWhiteColor,
                              onChange: (e) async {
                                log("=====");
                                setState(() {
                                  selectedCity = e.toString().toLowerCase();
                                });
                                log("----> $selectedCity");
                                if (e.toString() == "Current Location") {
                                } else {
                                  allServicesController.loadPage(true);
                                  await allServicesController.getAllServices();
                                  allServicesController.loadPage(false);
                                }
                                allServicesController.loadPage(true);
                                await allServicesController
                                    .getAllServicesByCityName(
                                        e.toString().toLowerCase());
                                allServicesController.loadPage(false);
                              }),
                        ),
                        SizedBox(
                          width: 8.w,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      // flex: 1,
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                categoriesController.allCategories.length,
                            itemBuilder: (context, index) {
                              return CommonCategoryWidget(
                                  onTap: () async {
                                    log(selectedCity);
                                    setState(() {
                                      selectedCategory = categoriesController
                                          .allCategories[index]
                                          .toString();
                                    });
                                    allServicesController.loadPage(true);
                                    await allServicesController
                                        .getAllServicesByCategoryName(
                                            categoriesController
                                                .allCategories[index]
                                                .toString()
                                                .toLowerCase(),
                                            selectedCity);
                                    allServicesController.loadPage(false);
                                  },
                                  isSelected: selectedCategory ==
                                          categoriesController
                                              .allCategories[index]
                                              .toString()
                                      ? true
                                      : false,
                                  text: categoriesController
                                      .allCategories[index]
                                      .toString());
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  allServicesController.isLoading.value
                      ? ListView.builder(
                          itemCount: 3,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            return const ServiceShimmer();
                          })
                      : allServicesController.allServices.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text("no_services_found".tr),
                              ),
                            )
                          : Expanded(
                              child: viewType == "list"
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: ListView.builder(
                                          itemCount: allServicesController
                                              .allServices.length,
                                          shrinkWrap: true,
                                          itemBuilder: (_, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                bool status =
                                                    await checkLoginStatus();
                                                if (status == true) {
                                                  Util.showServiceDetails(
                                                      context,
                                                      allServicesController
                                                          .allServices[index]);
                                                } else {
                                                  Util.showLoginRequiredPopup(
                                                      context, () {
                                                    Get.toNamed(routeLogin);
                                                  });
                                                }
                                              },
                                              child: CommonUserServicesWidget(
                                                description:
                                                    allServicesController
                                                            .allServices[index]
                                                            .description ??
                                                        "",
                                                title: allServicesController
                                                        .allServices[index]
                                                        .title ??
                                                    "",
                                                phone: allServicesController
                                                        .allServices[index]
                                                        .phone ??
                                                    "",
                                                imgUrl: allServicesController
                                                        .allServices[index]
                                                        .serviceImageUrl ??
                                                    '',
                                                isServiceByMe: false,
                                              ),
                                            );
                                          }),
                                    )
                                  : GoogleMap(
                                      // on below line setting camera position
                                      initialCameraPosition: _kGoogle,
                                      markers: Set<Marker>.of(marker),
                                      // on below line specifying map type.
                                      mapType: MapType.normal,
                                      // on below line setting user location enabled.
                                      myLocationEnabled: true,
                                      // on below line setting compass enabled.
                                      compassEnabled: true,
                                      // on below line specifying controller on map complete.
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                    ),
                            ),
                ],
              ),
            ),
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      if (viewType == "list") {
                        setState(() {
                          viewType = "map";
                        });
                      } else {
                        setState(() {
                          viewType = "list";
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          color: const Color(0xFFFFE8FF),
                          border: Border.all(color: AppColors.kMainColor)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            viewType == "map"
                                ? AppAssets.menuIcon
                                : AppAssets.mapIcon,
                            height: viewType == "map" ? 12.h : 16.h,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            capitalize(
                                viewType == "list" ? "map".tr : "list".tr),
                            style: AppTextStyle.bodyNormal14
                                .copyWith(color: AppColors.kMainColor),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        });
      });
    });
  }
}
