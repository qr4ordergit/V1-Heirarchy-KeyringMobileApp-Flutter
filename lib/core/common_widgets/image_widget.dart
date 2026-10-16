  import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
  import 'package:flutter/material.dart';
  import 'package:iconsax_flutter/iconsax_flutter.dart';
  // import 'package:messaging/core/device/device_utility.dart';


  class ImageWidget extends StatelessWidget {
    const ImageWidget({
      super.key,
      required this.imageUrl,
      this.isNetworkImage = true,
      this.width,
      this.setDefaultProfile = true,
      this.height,
      this.radius,
      this.fit = BoxFit.cover,
      this.errorFallback,
    });

    final bool isNetworkImage;
    final bool setDefaultProfile;
    final String imageUrl;
    final double? width;
    final double? height;
    final double? radius;
    final BoxFit fit;
    final Widget? errorFallback;

    @override
    Widget build(BuildContext context) {
      final Widget image = isNetworkImage
          ? Text("Network Image")
      // CachedNetworkImage(
      //   imageUrl: imageUrl,
      //   width: width,
      //   height: height,
      //   fit: fit,
      //   placeholder: (context, url) => Container(
      //     width: width,
      //     height: height,
      //     alignment: Alignment.center,
      //     child: SizedBox(
      //       width: 20,
      //       height: 20,
      //       child: DeviceUtility.loadingWidget(),
      //     ),
      //   ),
      //   errorWidget: (context, url, error) {
      //     if (errorFallback != null) return errorFallback!;
      //
      //     if (!setDefaultProfile) {
      //       return const SizedBox.shrink();
      //     }
      //
      //     return Container(
      //       width: width,
      //       height: height,
      //       alignment: Alignment.center,
      //       color: Theme.of(context).cardColor,
      //       child: const Icon(Iconsax.gallery_remove_copy),
      //     );
      //   },
      // )
          :
      Image.file(
        File(imageUrl),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (errorFallback != null) return errorFallback!;

          if (!setDefaultProfile) {
            return const SizedBox.shrink();
          }

          return Container(
            width: width,
            height: height,
            alignment: Alignment.center,
            color: Theme.of(context).cardColor,
            child: const Icon(Iconsax.gallery_remove_copy),
          );
        },
      );

      if (radius != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: image,
        );
      }

      return image;
    }
  }
