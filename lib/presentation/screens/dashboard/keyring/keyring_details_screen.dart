import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/common_widgets/icon_widget.dart';
import 'package:keyring/core/common_widgets/no_data_found_widget.dart';
import 'package:keyring/core/config/app_config.dart';
import 'package:keyring/core/device/device_utility.dart';
import 'package:keyring/core/enums/enums.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../data/models/keyring/keyring_model.dart';
import '../../../bloc/keyring/keyring_event.dart';
import '../../../bloc/keyring/keyring_state.dart';
import 'widgets/keyring_category_passwords_widget.dart';

class KeyringDetailsScreen extends StatefulWidget {
  final KeyringData keyringData;
  const KeyringDetailsScreen({super.key, required this.keyringData});

  @override
  State<KeyringDetailsScreen> createState() => _KeyringDetailsScreenState();
}

class _KeyringDetailsScreenState extends State<KeyringDetailsScreen> {
  late final KeyringBloc _keyringBloc;

  @override
  void initState() {
    super.initState();
    _keyringBloc = context.read<KeyringBloc>();
    initCall();
  }

  void initCall() {
    final keyring = widget.keyringData;

    final bool is2Factor = keyring.twoFa == true && keyring.secretKey?.isNotEmpty == true;

    if (is2Factor) {
      _keyringBloc.add(
        GetKeyringPasswordEvent(
          keyringCategoryId: keyring.id!,
          secretKey: keyring.secretKey!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconWidget(
          icon: Iconsax.arrow_circle_left_copy,
          iconSize: Sizes.iconLg,
          onTap: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(widget.keyringData.keyringCategoryName.toString(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm - 1), maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.sm),
        child: SingleChildScrollView(
          child: BlocBuilder<KeyringBloc, KeyringState>(
            builder: (context, state) {
              final index = state.keyringData.indexWhere(
                    (item) => item.id == widget.keyringData.id,
              );

              final keyring = index != -1
                  ? state.keyringData[index]
                  : widget.keyringData;

              final bool is2Factor =
                  keyring.twoFa == true &&
                      keyring.secretKey?.isNotEmpty == true;

              // Normal keyring: display existing passwords directly.
              if (!is2Factor) {
                return _buildKeyringContent(
                  context,
                  keyring,
                  is2Factor: false,
                );
              }

              // 2FA keyring: wait for API response.
              if (state.apiActionStatus == ApiStatus.loading) {
                return Center(
                  child: DeviceUtility.loadingWidget(),
                );
              }

              if (state.apiActionStatus == ApiStatus.failure) {
                return Center(
                  child: NoDataFoundWidget(
                    message: state.actionErrorMessage.toString(),
                    onRetry: () => Navigator.pop(context),
                  ),
                );
              }

              if (state.apiActionStatus == ApiStatus.success &&
                  state.verifiedKeyringCategoryId == keyring.id) {
                return _buildKeyringContent(
                  context,
                  keyring,
                  is2Factor: true,
                );
              }

              // API hasn't completed for this keyring yet.
              return Center(
                child: DeviceUtility.loadingWidget(),
              );
            },
          )

          // BlocBuilder<KeyringBloc, KeyringState>(
          //   // buildWhen: (p, c) => p.keyringData != c.keyringData,
          //   builder: (context, state) {
          //     // Find the latest version from Bloc state
          //     final index = state.keyringData.indexWhere(
          //           (item) => item.id == widget.keyringData.id,
          //     );
          //
          //     final keyring = index != -1
          //         ? state.keyringData[index]
          //         : widget.keyringData;
          //
          //     final bool is2Factor = keyring.twoFa == true && keyring.secretKey != null;
          //
          //     if(state.apiActionStatus == ApiStatus.loading) {
          //       return Center(child: DeviceUtility.loadingWidget());
          //     }
          //
          //     if(state.apiActionStatus == ApiStatus.failure) {
          //       return Center(child: NoDataFoundWidget(message: state.actionErrorMessage.toString(), onRetry: () => Navigator.pop(context)));
          //     }
          //
          //     if(state.apiActionStatus == ApiStatus.success) {
          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           if (keyring.keyringCategoryPasswords?.isNotEmpty == true)
          //             ...[
          //               SizedBox(height: Sizes.sm),
          //               Text(passwords, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm)),
          //               SizedBox(height: Sizes.sm),
          //               KeyringCategoryPasswordsWidget(keyring: keyring)
          //             ],
          //
          //           if(is2Factor)
          //             ...[
          //               SizedBox(height: Sizes.md),
          //               Container(
          //                 padding: EdgeInsets.all(Sizes.md),
          //                 decoration: BoxDecoration(
          //                     color: Theme.of(context).cardColor,
          //                     borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
          //                 ),
          //                 child: Row(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     IconWidget(
          //                       backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          //                       radius: Sizes.circularRadius,
          //                       icon: Iconsax.info_circle_copy, iconColor: Theme.of(context).primaryColor,
          //                       paddingAll: Sizes.sm,
          //                     ),
          //                     SizedBox(width: Sizes.md),
          //                     Expanded(
          //                       child: Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Text(aboutTOTP, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm)),
          //                           SizedBox(height: Sizes.xs),
          //                           Text(totpDes, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs)),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ]
          //
          //         ],
          //       );
          //     }
          //
          //     return SizedBox.shrink();
          //
          //   },
          // ),
        ),
      ),
    );
  }

  Widget _buildKeyringContent(
      BuildContext context,
      KeyringData keyring, {
        required bool is2Factor,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (keyring.keyringCategoryPasswords?.isNotEmpty == true) ...[
          SizedBox(height: Sizes.sm),
          Text(
            passwords,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: Sizes.fontSizeSm),
          ),
          SizedBox(height: Sizes.sm),
          KeyringCategoryPasswordsWidget(keyring: keyring),
        ],

        if (is2Factor) ...[
          SizedBox(height: Sizes.md),
          Container(
            padding: EdgeInsets.all(Sizes.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(
                Sizes.borderRadiusLg,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconWidget(
                  backgroundColor: Theme.of(context)
                      .primaryColor
                      .withValues(alpha: 0.2),
                  radius: Sizes.circularRadius,
                  icon: Iconsax.info_circle_copy,
                  iconColor: Theme.of(context).primaryColor,
                  paddingAll: Sizes.sm,
                ),
                SizedBox(width: Sizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        aboutTOTP,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: Sizes.fontSizeSm),
                      ),
                      SizedBox(height: Sizes.xs),
                      Text(
                        totpDes,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: Sizes.fontSizeXs),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
