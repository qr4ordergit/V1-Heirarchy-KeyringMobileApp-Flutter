import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../main.dart';
import '../config/app_config.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'package:flutter/material.dart';
import '../enums/enums.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class SnackBars {

  static void snackMessage(BuildContext context, {
    String? title,
    required String description,
    IconData? icon,
    MessageType? messageType,
    int? days,
    bool? isDismissible = true,
  }) {
    final ctx = rootNavigatorKey.currentContext ?? context; // stable, survives any sheet/route disposal

    return DelightToastBar(
      builder: (context) => ToastCard(
        color: Theme.of(context).primaryColor,
        // color: messageType == MessageType.error ? AppColors.red : Theme.of(context).primaryColor,
        leading: Icon(
          icon == null
              ? messageType == MessageType.success
              ? Iconsax.tick_circle
              : messageType == MessageType.error
              ? Iconsax.danger_copy
              : Iconsax.info_circle_copy
              : Iconsax.info_circle_copy,
          color: AppColors.light,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? message, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: Sizes.fontSizeSm, color: AppColors.light)),
            Text(description, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: Sizes.fontSizeXs, color: AppColors.light)),
          ],
        ),
      ),
      position: DelightSnackbarPosition.top,
      autoDismiss: isDismissible!,
      snackbarDuration: days == null ? const Duration(seconds: 3) : Duration(days: days),
    ).show(ctx);
  }
}


// class SnackBars {
//
//   static void snackMessage(BuildContext context, {
//     String? title,
//     required String description,
//     IconData? icon,
//     MessageType? messageType,
//   }) {
//     final messenger = ScaffoldMessenger.of(context);
//
//     messenger.showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             IconWidget(
//               icon: icon == null
//                 ? messageType == MessageType.success
//                 ? Iconsax.tick_circle
//                 : messageType == MessageType.error
//                 ? Iconsax.danger_copy
//                 : Iconsax.info_circle_copy
//                 : Iconsax.info_circle_copy,
//               iconColor: AppColors.dark,
//               backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.1),
//               radius: Sizes.circularRadius,
//               paddingAll: Sizes.sm,
//             ),
//             SizedBox(width: Sizes.sm),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title ?? message, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: Sizes.fontSizeSm, color: AppColors.dark)),
//                   Text(description, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: Sizes.fontSizeXs, color: AppColors.dark)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: messageType == MessageType.error ? AppColors.red : Theme.of(context).primaryColor,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//         margin: EdgeInsets.only(
//           bottom: MediaQuery.of(context).size.height - 120,
//           left: Sizes.sm,
//           right: Sizes.sm,
//         ),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
//         ),
//         padding: EdgeInsets.all(Sizes.md),
//         dismissDirection: DismissDirection.horizontal,
//         animation: CurvedAnimation(
//           parent: const AlwaysStoppedAnimation(1.0),
//           curve: Curves.easeOutCubic,
//         ),
//       ),
//     );
//   }
// }