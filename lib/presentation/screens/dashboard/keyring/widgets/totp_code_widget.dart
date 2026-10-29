// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:keyring/core/common_widgets/icon_widget.dart';
// import 'package:keyring/core/common_widgets/no_data_found_widget.dart';
// import 'package:keyring/core/constants/app_colors.dart';
// import 'package:keyring/core/device/device_utility.dart';
// import 'package:keyring/domain/repositories/totp/totp_repository.dart';
// import 'package:keyring/presentation/screens/dashboard/keyring/widgets/totp_success_widget.dart';
// import 'package:keyring/presentation/screens/dashboard/keyring/widgets/totp_verification_widget.dart';
// import '../../../../core/config/app_config.dart';
// import '../../../../core/constants/app_sizes.dart';
// import '../../../../core/enums/enums.dart';
// import '../../../bloc/keyring/keyring_bloc.dart';
// import '../../../bloc/keyring/keyring_event.dart';
// import '../../../bloc/keyring/keyring_state.dart';
// import '../../../cubit/totp/totp_cubit.dart';
// import '../../../cubit/totp/totp_state.dart';
//
// class TotpCodeWidget extends StatelessWidget {
//   final String secretKey;
//   final String keyringCategoryId;
//   const TotpCodeWidget({super.key, required this.secretKey, required this.keyringCategoryId});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return BlocProvider(
//       key: ValueKey(secretKey),
//       create: (context) => TotpCubit(
//         repository: context.read<TotpRepository>(),
//         interval: context.read<KeyringBloc>().state.interval,
//         secretKey: secretKey,
//       )..start(keyringCategoryId: keyringCategoryId),
//       child: _TotpCodeView(
//         keyringCategoryId: keyringCategoryId,
//       ),
//     );
//   }
// }
//
// class _TotpCodeView extends StatelessWidget {
//   final String keyringCategoryId;
//
//   const _TotpCodeView({
//     required this.keyringCategoryId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return BlocListener<KeyringBloc, KeyringState>(
//       listenWhen: (p, c) => p.interval != c.interval,
//       listener: (context, state) {
//         context.read<TotpCubit>().updateInterval(
//           interval: state.interval,
//           keyringCategoryId: keyringCategoryId,
//         );
//       },
//       child: BlocConsumer<TotpCubit, TotpState>(
//         listenWhen: (previous, current) {
//           return current.remainingSeconds > previous.remainingSeconds;
//         },
//         listener: (context, state) {
//           context.read<KeyringBloc>().add(
//             ResetKeyringActionEvent(
//               keyringCategoryId: keyringCategoryId,
//             ),
//           );
//         },
//         builder: (context, totpState) {
//           return Container(
//             width: double.infinity,
//             // padding: const EdgeInsets.all(Sizes.md + 4),
//             padding: const EdgeInsets.all(Sizes.md),
//             decoration: BoxDecoration(
//                 color: theme.cardColor,
//                 borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(authenticationCode, style: theme.textTheme.titleMedium),
//
//                     IconWidget(
//                       backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
//                       radius: Sizes.circularRadius,
//                       icon: Iconsax.copy_copy,
//                       iconColor: Theme.of(context).primaryColor,
//                       iconSize: Sizes.iconSm,
//                       paddingAll: Sizes.sm,
//                       onTap: () {
//                         if (totpState.otpCode.length == 6) {
//                           Clipboard.setData(
//                             ClipboardData(text: totpState.otpCode),
//                           );
//                         }
//                       },
//                     )
//                   ],
//                 ),
//                 SizedBox(height: Sizes.md),
//
//                 if (totpState.errorMessage != null)
//                   Text(totpState.errorMessage!, textAlign: TextAlign.center, style: TextStyle(color: theme.colorScheme.error))
//                 else
//                   Text(
//                     totpState.otpCode.length == 6
//                         ? '${totpState.otpCode.substring(0, 3)} '
//                         '${totpState.otpCode.substring(3)}'
//                         : '------',
//                     style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 4,color: AppColors.teal),
//                   ),
//
//                 SizedBox(height: Sizes.md),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Icon(
//                       Iconsax.timer_1_copy,
//                       size: Sizes.iconSm,
//                       color: AppColors.teal,
//                     ),
//                     const SizedBox(width: Sizes.xs),
//                     RichText(
//                       text: TextSpan(
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                           fontSize: Sizes.fontSizeXs,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: '$refreshesIn ',
//                             style: TextStyle(color: AppColors.teal),
//                           ),
//                           TextSpan(
//                             text: '${totpState.remainingSeconds}',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                           TextSpan(
//                             text: 's',
//                             style: TextStyle(color: AppColors.teal),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           Text(
//                             '${context.watch<KeyringBloc>().state.interval}s',
//                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                               fontSize: Sizes.fontSizeXs,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: Sizes.sm),
//
//                 ShaderMask(
//                   shaderCallback: (bounds) => LinearGradient(
//                     colors: totpState.remainingSeconds <= 10
//                         ? [
//                       AppColors.red,
//                       AppColors.orange,
//                       AppColors.teal,
//                     ] : [
//                       AppColors.teal.withValues(alpha: 0.85),
//                       AppColors.teal,
//                       const Color(0xFF80CBC4),
//                     ],
//                   ).createShader(bounds),
//                   child: LinearProgressIndicator(
//                     value: totpState.remainingSeconds / context.read<KeyringBloc>().state.interval,
//                     backgroundColor: AppColors.greyShade,
//                     minHeight: 5,
//                     borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
//                   ),
//                 ),
//
//
//                 SizedBox(height: Sizes.md),
//                 DeviceUtility.divider(),
//                 SizedBox(height: Sizes.md),
//
//                 BlocBuilder<KeyringBloc, KeyringState>(
//                   buildWhen: (previous, current) =>
//                   previous.apiActionStatus != current.apiActionStatus,
//                   builder: (context, keyringState) {
//                     final isLoading = keyringState.apiActionStatus == ApiStatus.loading && keyringState.verifiedKeyringCategoryId == keyringCategoryId;
//
//                     final isSuccess = keyringState.apiActionStatus == ApiStatus.success &&
//                         keyringState.verifiedKeyringCategoryId == keyringCategoryId;
//
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         isSuccess ?
//                         TotpSuccessWidget() :
//
//                         TotpVerificationWidget(
//                           keyringCategoryId: keyringCategoryId,
//                           isLoading: isLoading,
//                           otpCode: totpState.otpCode,
//                           errorMessage: totpState.errorMessage,
//                         ),
//
//                         if (keyringState.apiActionStatus == ApiStatus.failure)
//                           NoDataFoundWidget(message: keyringState.actionErrorMessage ?? 'OTP verification failed'),
//
//                       ],
//                     );
//                   },
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }