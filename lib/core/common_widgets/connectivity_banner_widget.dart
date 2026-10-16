// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../config/app_config.dart';
// import '../constants/app_colors.dart';
// import '../constants/app_sizes.dart';
// import '../enums/enums.dart';
// import '../extensions/build_context_extension.dart';
//
// class ConnectivityBannerWidget extends StatelessWidget {
//   const ConnectivityBannerWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<InternetCubit, InternetStatus>(
//       builder: (context, state) {
//         if (state.status == ConnectivityStatus.disconnected) {
//           return Container(
//             width: context.screenWidth * 0.9,
//             padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
//             margin: EdgeInsets.only(top: Sizes.sm),
//             decoration: BoxDecoration(
//                 color: AppColors.greyShade,
//                 borderRadius: BorderRadius.circular(Sizes.circularRadius)
//             ),
//             child: Text(
//               noInternetConnection,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.red, fontWeight: FontWeight.w600, fontSize: Sizes.fontSizeXs),
//             ),
//           );
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
