// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../../constants/app_colors.dart';
// import '../../constants/app_sizes.dart';
// class CupertinoAppListTile extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final IconData? leadingIcon;
//   final IconData? trailingIcon;
//   final bool isLoading;
//   final Color? titleColor;
//   final VoidCallback? onTap;
//   final VoidCallback? onLeadingTap;
//   final VoidCallback? onTrailingTap;
//   final double? titleFontSize;
//   final Color? backgroundColor;
//   final double? borderRadius;
//
//   const CupertinoAppListTile({
//     super.key,
//     required this.title,
//     this.subtitle,
//     this.leadingIcon,
//     this.trailingIcon,
//     this.isLoading = false,
//     this.titleColor,
//     this.onTap,
//     this.onLeadingTap,
//     this.onTrailingTap,
//     this.titleFontSize,
//     this.backgroundColor,
//     this.borderRadius,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(borderRadius ?? Sizes.borderRadiusSm),
//       child: CupertinoListTile(
//         backgroundColor: backgroundColor,
//         title: Text(
//           title,
//           style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
//             fontSize: titleFontSize ?? Sizes.fontSizeSm - 1,
//             fontWeight: FontWeight.w500,
//             color: titleColor,
//           ),
//         ),
//         subtitle: subtitle != null
//             ? Text(
//           subtitle!,
//           maxLines: 2,
//           style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
//             fontSize: Sizes.fontSizeSm - 2,
//             color: AppColors.grey,
//           ),
//         )
//             : null,
//         leading: leadingIcon != null
//             ? GestureDetector(
//           onTap: onLeadingTap,
//           child: Icon(leadingIcon, size: Sizes.iconMd, color: Theme.of(context).primaryColor),
//         )
//             : null,
//         trailing: isLoading
//             ? const CupertinoActivityIndicator()
//             : (trailingIcon != null
//             ? GestureDetector(
//           onTap: onTrailingTap,
//           child: Icon(trailingIcon, size: Sizes.iconMd, color: Theme.of(context).primaryColor),
//         )
//             : null),
//         onTap: isLoading ? null : onTap,
//       ),
//     );
//   }
// }