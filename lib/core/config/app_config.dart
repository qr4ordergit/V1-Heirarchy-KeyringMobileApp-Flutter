import 'package:flutter/material.dart';

Color primaryColor = const Color(0xff778bff);
// Color primaryColor = const Color(0xff6a3de8);
// Color primaryColor = const Color(0xff0057b8); // dark logo blue


String redirectUrl = "https://messaging.thenodeai.com/#/";

String appName = "Keyring Safe";
String secureAccess = "Secure Access";
String welcomeBack = "Welcome Back";
String usernameOrEmail = "Username or email";
String signInMsg = "Sign in to your account to manage keyring and two factor codes.";
String signIn = "Sign In Securely";
String enterValidPassword = "Enter Valid Password";
String password = "Password";
String passwords = "Passwords";
String passwordSub = "Enter password";
String enterValidUsername = "Enter Valid Username";
String usernameLabel = "Username";
String enterUsernameOrEmail = "Enter Username or email";
String signInSuccess = "Welcome back! 👋 You’ve signed in successfully. Enjoy connecting and chatting with your contacts.";
String message = "Message";
String retry = "Retry";
String twoFaEnabled = "2FA Enabled";
String aboutTOTP = "About TOTP";
String totpDes = "TOTP (Time-based One-Time Password) generates a new 6-digit code every 30 seconds. Use this code when asked during 2FA verification.";
String authenticationCode = "Authentication Code";
String secretKeyIsUnavailable = "Secret key is unavailable'";
String unableToGenerateOtp = "Unable to generate OTP";
String otpVerifiedSuccessfully = "OTP verified successfully";
String getPasswords = "Access Your Passwords";
String getPasswordDes = "Verify your identity with your authenticator code to securely access your saved passwords.";
String passwordVerified = "Verification Successful";
String passwordVerifiedDes = "Your identity has been verified successfully. You can now securely access your saved passwords.";
String verify = "Verify";
String secure = "Your Security, Our Priority";
String secureDes = "Protect your contact with Keyring's 2FA and TOTP security.";
String searchKeyringCategory = "Search Keyring Category";
String encrypted$TwoFa = "Encrypted & 2FA protected";
String things = "";

// static void snackMessage(BuildContext context, {
//   String? title,
//   required String description,
//   IconData? icon,
//   MessageType? messageType,
//   int? days,
//   bool? isDismissible = true,
// }) {
//   final ctx = context;
//   // final ctx = rootNavigatorKey.currentContext ?? context; // stable, survives any sheet/route disposal
//
//   return DelightToastBar(
//     builder: (context) => ToastCard(
//       color: messageType == MessageType.error ? AppColors.red : Theme.of(context).primaryColor,
//       leading: Icon(
//         icon == null
//             ? messageType == MessageType.success
//             ? Iconsax.tick_circle
//             : messageType == MessageType.error
//             ? Iconsax.danger_copy
//             : Iconsax.info_circle_copy
//             : Iconsax.info_circle_copy,
//         color: AppColors.light,
//       ),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title ?? message, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: Sizes.fontSizeSm, color: AppColors.light)),
//           Text(description, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500, fontSize: Sizes.fontSizeXs, color: AppColors.light)),
//         ],
//       ),
//     ),
//     position: DelightSnackbarPosition.top,
//     autoDismiss: isDismissible!,
//     snackbarDuration: days == null ? const Duration(seconds: 3) : Duration(days: days),
//   ).show(ctx);
// }

