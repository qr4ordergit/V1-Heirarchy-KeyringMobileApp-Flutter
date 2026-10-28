import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../common_widgets/Icon_title_row.dart';
import '../config/app_config.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

/// Imperative, context-driven "show something over the current screen"
/// helpers: bottom sheets, modal popups, action sheets. These aren't
/// widgets in the tree — they push UI and return a Future — so they live
class SheetService {
  SheetService._();

  // ==================== Material ====================
  // static Future<T?> materialBottomSheet<T>(BuildContext context, {
  //   required Widget child,
  //   double? height,
  //   double? width,
  //   bool isDismissible = true,
  //   bool enableDrag = true,
  //   bool isScrollControlled = true,
  //   Color? backgroundColor,
  //   double radius = 20,
  // }) {
  //   return showModalBottomSheet<T>(
  //     context: context,
  //     isDismissible: isDismissible,
  //     enableDrag: enableDrag,
  //     isScrollControlled: isScrollControlled,
  //     backgroundColor: backgroundColor,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(radius),
  //       ),
  //     ),
  //     builder: (BuildContext context) {
  //       return Container(
  //           height: height,
  //           width: width ?? double.infinity,
  //           padding: EdgeInsets.only(
  //             left: Sizes.sm - 2,
  //             right: Sizes.sm - 2,
  //             top: Sizes.sm,
  //             bottom: MediaQuery.of(context).viewInsets.bottom,
  //           ),
  //           child: Column(
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.only(bottom: Sizes.sm/2),
  //                 width: Sizes.xxl - 25,
  //                 height: Sizes.sm,
  //                 decoration: BoxDecoration(
  //                     color: AppColors.greyShade,
  //                     borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
  //                 ),
  //               ),
  //               Flexible(child: child)
  //             ],
  //           )
  //       );
  //     },
  //   );
  // }
  static Future<T?> showMaterialBottomSheet<T>(
      BuildContext context, {
        required Widget child,
        double? height,
        double? width,
        bool isDismissible = true,
        bool enableDrag = true,
        bool isScrollControlled = true,
        Color? backgroundColor,
        double radius = 20,
      }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      ),
      builder: (BuildContext context) {
        return PopScope(
          canPop: isDismissible,
          child: Container(
            height: height,
            width: width ?? double.infinity,
            padding: EdgeInsets.only(
              left: Sizes.sm - 2,
              right: Sizes.sm - 2,
              top: Sizes.sm,
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: height == null
                  ? MainAxisSize.min
                  : MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: Sizes.sm/2),
                  width: Sizes.xxl - 25,
                  height: Sizes.sm,
                  decoration: BoxDecoration(
                      color: AppColors.greyShade,
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
                  ),
                ),
                if (height == null)
                  child
                else
                  Flexible(child: child),
                // Flexible(child: child)
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== Cupertino ====================

  static Future<T?> showCupertinoPopup<T>(
      BuildContext context, {
        required Widget child,
        double? height,
        double? width,
        bool barrierDismissible = true,
        bool isScrolling = true,
      }) {
    return showCupertinoModalPopup<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(
            left: Sizes.sm - 2,
            right: Sizes.sm - 2,
            top: Sizes.sm,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: Sizes.sm),
            child: CupertinoPopupSurface(
              child: Padding(
                padding: const EdgeInsets.all(Sizes.sm),
                child: isScrolling
                    ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: child,
                )
                    : child,
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> showCupertinoActionSheet(
      BuildContext context, {
        required String title,
        required String message,
        required List<Widget> actions,
        required String closeLabel,
        bool canPop = true,
        bool barrierDismissible = true,
        bool isLoading = false,
        double? modalWidth,
        Function(bool, dynamic)? onPopInvokedWithResult,
      }) {
    return showCupertinoModalPopup(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: modalWidth,
          child: PopScope(
            canPop: canPop,
            onPopInvokedWithResult: onPopInvokedWithResult,
            child: CupertinoActionSheet(
              title: Text(
                title,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(fontSize: Sizes.fontSizeMd),
              ),
              message: Text(message),
              actions: actions,
              cancelButton: CupertinoActionSheetAction(
                onPressed: isLoading ? () {} : () => Navigator.pop(context),
                child: IconTitleRow(
                  icon: Iconsax.arrow_circle_down_copy,
                  title: closeLabel,
                  titleColor: primaryColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}