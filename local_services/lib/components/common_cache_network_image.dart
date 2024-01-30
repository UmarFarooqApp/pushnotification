import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_services/components/shimmers/image_shimmers.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imgUrl;
  final double height, width;
  final double? borderRadius;
  final BoxFit? boxFit;
  final String errorImg;
  final Color? errorImgColor;
  final String? errorSvg;

  const CustomCachedNetworkImage({
    Key? key,
    required this.imgUrl,
    required this.height,
    required this.width,
    this.borderRadius,
    required this.errorImg,
    this.errorImgColor,
    this.boxFit,
    this.errorSvg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius != null
          ? BorderRadius.circular(borderRadius!)
          : BorderRadius.circular(8.r),
      child: CachedNetworkImage(
        imageUrl: imgUrl,

        maxHeightDiskCache: int.tryParse(height.toString()),
        maxWidthDiskCache: int.tryParse(width.toString()),
        progressIndicatorBuilder: (context, url, progress) {
          return const ImageShimmer();
        },
        // progressIndicatorBuilder: (context, url, downloadProgress) =>
        //     const Center(child: CircularProgressIndicator.adaptive()),
        errorWidget: (context, url, error) => errorImg.isNotEmpty
            ? ClipRRect(
            borderRadius: borderRadius != null?BorderRadius.circular(borderRadius!.r):BorderRadius.circular(10.r),
                // borderRadius != null
                //     ? BorderRadius.circular(borderRadius!)
                //     : null,
                child: Image.asset(
                  errorImg,
                  width: height,
                  height: width,
                  color: errorImgColor,
                  fit: boxFit ?? BoxFit.fill,
                ))
            : const SizedBox(),
        height: height,
        width: width,
        fit: boxFit ?? BoxFit.cover,
      ),
    );
  }
}
