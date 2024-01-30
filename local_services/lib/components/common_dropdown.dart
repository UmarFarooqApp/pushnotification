// ignore_for_file: must_be_immutable

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_services/helpers/app_colors.dart';
import 'package:local_services/helpers/app_textstyle.dart';
import 'package:local_services/utils/extra_functions.dart';

class CommonDropdownButton extends StatefulWidget {
  final List items;
  void Function(dynamic) onSaved;
  String? hintText;
  String? value;
  void Function(dynamic) onChange;
  String? label;
  bool? showShadow;
  Color? textColor;
  Color? borderColor;
  final bool showOffset;
  Color? labelColor;
  double? borderRadius;
  bool? showBorder;
  bool? showPadding;
  bool? dropdownHeight;
  CommonDropdownButton({
    Key? key,
    required this.items,
    required this.showOffset,
    required this.onSaved,
    this.hintText,
    this.borderRadius,
    this.value,
    this.label,
    this.showShadow,
    required this.onChange,
    this.borderColor,
    this.textColor,
    this.showBorder,
    this.showPadding,
    this.labelColor,
    // this.isFilled,
    this.dropdownHeight,
  }) : super(key: key);

  @override
  State<CommonDropdownButton> createState() => _CommonDropdownButtonState();
}

class _CommonDropdownButtonState extends State<CommonDropdownButton> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Text(
                widget.label!,
                style: AppTextStyle.bodyNormal12.copyWith(
                  color: widget.labelColor ?? AppColors.kTextPrimaryColor,
                  fontSize:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 12.sp
                          : 8.sp,
                ),
              )
            : const SizedBox(),
        widget.label != null
            ? SizedBox(
                height: 8.h,
              )
            : SizedBox(
                height: 0.h,
              ),
        Container(
          height: widget.dropdownHeight != null ? 30.h : 50.h,
          decoration: BoxDecoration(
              color: AppColors.kWhiteColor,
              boxShadow: widget.showShadow != null
                  ? [
                      BoxShadow(
                          color:
                              AppColors.kTextFieldShadowColor.withOpacity(0.10),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ]
                  : []),
          child: DropdownButtonFormField2(
            dropdownStyleData: DropdownStyleData(
                decoration: const BoxDecoration(color: AppColors.kWhiteColor),
                maxHeight: 200.h,
                width: 300.w,
                offset: widget.showOffset ? Offset(-220, -6) : Offset(0, 0)),
            iconStyleData: IconStyleData(
                iconEnabledColor: widget.textColor ?? AppColors.kMainColor),
            decoration: InputDecoration(
              contentPadding: widget.showPadding != null
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      top: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 18.h
                          : 0.h,
                      bottom: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 12.h
                          : 32.h,
                      left: 12.w,
                      right: 12.w),
              fillColor: AppColors.kWhiteColor,
              // : AppColors.kWhiteColor,
              filled: true,
              border: widget.showBorder == true
                  ? OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius ?? 8.r),
                      borderSide: BorderSide(
                          color:
                              widget.borderColor ?? AppColors.kTextPrimaryColor,
                          width: 0.5),
                    )
                  : const UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: widget.showBorder == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? widget.borderRadius ?? 8.r
                              : widget.borderRadius ?? 20.r),
                      borderSide: BorderSide(
                          color:
                              widget.borderColor ?? AppColors.kTextPrimaryColor,
                          width: 0.5),
                    )
                  : const UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: widget.showBorder == true
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? widget.borderRadius ?? 8.r
                              : widget.borderRadius ?? 20.r),
                      borderSide: BorderSide(
                          color:
                              widget.borderColor ?? AppColors.kTextPrimaryColor,
                          width: 0.5),
                    )
                  : const UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            isExpanded: true,
            hint: Text(
              widget.hintText ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodyNormal12.copyWith(
                  color: widget.textColor ?? AppColors.kTextPrimaryColor),
            ),
            items: widget.items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      capitalize(item),
                      style: AppTextStyle.bodyNormal12.copyWith(
                          color: widget.textColor ?? AppColors.kMainColor,
                          fontSize: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 12.sp
                              : 10.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            value: widget.value,
            onSaved: widget.onSaved,
            onChanged: widget.onChange,
          ),
        ),
      ],
    );
  }
}
