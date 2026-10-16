import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../device/device_utility.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    this.fontSize,
    this.enabled,
    this.readOnly,
    this.isLoading,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.inputFormatters,
    this.hintText,
    this.labelText,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofillHints,
    this.obscureText,
    this.autofocus,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.radius,
    this.suffixText,
    this.prefixPressed,
    this.suffixPressed,
    this.onTap,
    this.suffixWidget,
    this.onChanged,
    this.maxLines,
    this.validator,
    this.height,
    this.width,
    this.backgroundColor,
    this.autoValidateMode,
    this.contentPadding,
    this.border = false,
  });

  final TextEditingController? controller;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final String? hintText;
  final String? labelText;
  final String? suffixText;
  final double? fontSize;
  final double? radius;
  final bool? readOnly;
  final bool? isLoading;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool? autofocus;
  final int? maxLines;
  final void Function()? prefixPressed;
  final void Function()? suffixPressed;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final bool? border;
  final AutovalidateMode? autoValidateMode;
  final Widget? suffixWidget;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        maxLines: maxLines ?? 1,
        onTap: onTap,
        onChanged: onChanged,
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        onFieldSubmitted: onFieldSubmitted,
        readOnly: readOnly ?? false,
        autofocus: autofocus ?? false,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        validator: validator,
        // textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.left,
        // cursorColor: primaryColor,
        autovalidateMode: autoValidateMode,
        style: TextStyle(
          decoration: TextDecoration.none,
          decorationThickness: 0,
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          fillColor: backgroundColor ?? Theme.of(context).cardColor,
          filled: true,
          // filled: backgroundColor == null ? false : true,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0, // Very small vertical padding
            ),
            isDense: true,
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(fontSize: Sizes.fontSizeSm - 2),
          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: Sizes.fontSizeSm - 2),
          prefixIcon: prefixIcon != null
              ? IconButton(
            icon: Icon(prefixIcon, color: prefixIconColor),
            // icon: Icon(prefixIcon, color: Theme.of(context).primaryColor),
            onPressed: prefixPressed,
          ) : null,
          // suffix: suffixWidget,
          suffixIcon: suffixWidget ?? (suffixIcon != null
              ? isLoading == true ? DeviceUtility.loadingWidget() : IconButton(
            color: suffixIconColor,
            icon: Icon(suffixIcon),
            onPressed: isLoading == true ? null : suffixPressed,
          )
              : null),
          suffixText: suffixText,
            errorStyle: TextStyle(
              fontSize: Sizes.fontSizeSm - 4,
              color: AppColors.error,
              fontWeight: FontWeight.w400,
            ),
          border: OutlineInputBorder(
            borderSide: border == true ? BorderSide(color: AppColors.grey.withValues(alpha: 0.4),) : BorderSide.none,
            borderRadius: BorderRadius.circular(radius ??  Sizes.borderRadiusLg),
          ) ,
          enabledBorder: OutlineInputBorder(
            borderSide: border == true ? BorderSide(color: AppColors.grey.withValues(alpha: 0.4),) : BorderSide.none,
            borderRadius: BorderRadius.circular(radius ?? Sizes.borderRadiusLg),
          ) ,
          focusedBorder: OutlineInputBorder(
            borderSide: border == true ? BorderSide(color: Theme.of(context).primaryColor) : BorderSide.none,
            borderRadius: BorderRadius.circular(radius ?? Sizes.borderRadiusLg),
          ) ,
          errorBorder: OutlineInputBorder(
            borderSide: border == true ? BorderSide(color: AppColors.error) : BorderSide.none,
            borderRadius: BorderRadius.circular(radius ?? Sizes.borderRadiusLg),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: border == true ? BorderSide(color: AppColors.error) : BorderSide.none,
            borderRadius: BorderRadius.circular(radius ?? Sizes.borderRadiusLg),
          )
        ),
        autofillHints: autofillHints,
      ),
    );
  }
}