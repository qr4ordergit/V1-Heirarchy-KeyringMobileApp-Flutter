// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl_phone_field/countries.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import 'package:messaging/core/constants/app_colors.dart';
// import 'package:messaging/core/device/device_utility.dart';
// import '../config/app_config.dart';
// import '../constants/app_sizes.dart';
//
// class IntlPhoneFieldWidget extends StatelessWidget {
//   const IntlPhoneFieldWidget({
//     super.key,
//     this.fontSize,
//     this.isLoading,
//     this.keyboardType,
//     this.textInputAction,
//     this.controller,
//     this.inputFormatters,
//     this.hintText,
//     this.labelText,
//     this.onFieldSubmitted,
//     this.focusNode,
//     this.radius,
//     this.prefixPressed,
//     this.suffixPressed,
//     this.onTap,
//     this.onChanged,
//     this.onCountryChanged,
//     this.maxLines,
//     this.validator,
//     this.height,
//     this.backgroundColor,
//     this.autoValidateMode,
//     this.border = false,
//     this.initialCountryCode = "IN",
//   });
//
//   final TextEditingController? controller;
//   final String? hintText;
//   final String? labelText;
//   final double? fontSize;
//   final double? radius;
//   final double? height;
//   final bool? isLoading;
//   final bool? border;
//   final TextInputAction? textInputAction;
//   final TextInputType? keyboardType;
//   final List<TextInputFormatter>? inputFormatters;
//   final void Function(String)? onFieldSubmitted;
//   final FocusNode? focusNode;
//   final int? maxLines;
//   final void Function()? prefixPressed;
//   final void Function()? suffixPressed;
//   final void Function()? onTap;
//   final void Function(PhoneNumber)? onChanged;
//   final void Function(Country)? onCountryChanged;
//   final String? Function(PhoneNumber?)? validator;
//   final Color? backgroundColor;
//   final AutovalidateMode? autoValidateMode;
//   final String initialCountryCode;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: height,
//       child: IntlPhoneField(
//         controller: controller,
//         focusNode: focusNode,
//         keyboardType: keyboardType ?? TextInputType.phone,
//         textInputAction: textInputAction,
//         inputFormatters: inputFormatters,
//         initialCountryCode: initialCountryCode,
//         onTap: onTap,
//         onChanged: (PhoneNumber phone) {
//           onChanged?.call(phone);
//         },
//         onCountryChanged: (Country country) {
//           onCountryChanged?.call(country);
//         },
//         validator: validator,
//         textAlign: TextAlign.left,
//         cursorColor: Theme.of(context).primaryColor,
//         autovalidateMode: autoValidateMode,
//         style: TextStyle(
//           decoration: TextDecoration.none,
//           decorationThickness: 0,
//           fontSize: fontSize,
//         ),
//         decoration: InputDecoration(
//           fillColor:
//           backgroundColor ?? Theme.of(context).cardColor,
//
//           filled: true,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: Sizes.md,
//             vertical: 0,
//           ),
//           isDense: true,
//           labelText: labelText,
//           hintText: hintText,
//           labelStyle: TextStyle(
//             fontSize: Sizes.fontSizeSm - 2,
//           ),
//           hintStyle: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: Sizes.fontSizeSm - 2,
//           ),
//           errorStyle: TextStyle(
//             fontSize: Sizes.fontSizeSm - 4,
//             color: AppColors.error,
//             fontWeight: FontWeight.w400,
//           ),
//           border: _border(context),
//           enabledBorder: _border(context),
//           focusedBorder: _border(
//             context,
//             color: Theme.of(context).primaryColor,
//           ),
//           errorBorder: _border(
//             context,
//             color: AppColors.error,
//           ),
//           focusedErrorBorder: _border(
//             context,
//             color: AppColors.error,
//           ),
//         ),
//       ),
//     );
//   }
//
//   OutlineInputBorder _border(
//       BuildContext context, {
//         Color? color,
//       }) {
//     return OutlineInputBorder(
//       borderSide: border == true
//           ? BorderSide(
//         color: color ??
//             AppColors.grey.withValues(alpha: 0.4),
//       )
//           : BorderSide.none,
//       borderRadius: BorderRadius.circular(
//         radius ?? 100,
//       ),
//     );
//   }
// }