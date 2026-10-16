import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/common_widgets/icon_widget.dart';
import 'package:keyring/core/config/app_config.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../data/models/keyring/keyring_model.dart';
import '../../../bloc/keyring/keyring_state.dart';
import 'totp_code_widget.dart';
import 'widgets/keyring_category_passwords_widget.dart';

class KeyringDetailsScreen extends StatefulWidget {
  const KeyringDetailsScreen({super.key});

  @override
  State<KeyringDetailsScreen> createState() => _KeyringDetailsScreenState();
}

class _KeyringDetailsScreenState extends State<KeyringDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final routeKeyring = ModalRoute.of(context)!.settings.arguments as KeyringData;

    return Scaffold(
      appBar: AppBar(
        leading: IconWidget(
          icon: Iconsax.arrow_circle_left_copy,
          iconSize: Sizes.iconLg,
          onTap: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(routeKeyring.keyringCategoryName.toString(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm - 1), maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.sm),
        child: BlocBuilder<KeyringBloc, KeyringState>(
          buildWhen: (p, c) => p.keyringData != c.keyringData,
          builder: (context, state) {
            // Find the latest version from Bloc state
            final index = state.keyringData.indexWhere(
                  (item) => item.id == routeKeyring.id,
            );

            final keyring = index != -1
                ? state.keyringData[index]
                : routeKeyring;

            final isTOTP = keyring.twoFa == true && keyring.secretKey != null;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOTP Section Start
                  if(isTOTP)
                    TotpCodeWidget(secretKey: keyring.secretKey!, keyringCategoryId: keyring.id!),
                  // TOTP Section End

                  if (keyring.keyringCategoryPasswords?.isNotEmpty == true)
                    ...[
                      SizedBox(height: Sizes.sm),
                      Text(passwords, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm)),
                      SizedBox(height: Sizes.sm),
                      KeyringCategoryPasswordsWidget(keyring: keyring)
                    ],

                  if(isTOTP)
                    ...[
                      SizedBox(height: Sizes.md),
                      Container(
                        padding: EdgeInsets.all(Sizes.md),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconWidget(
                              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                              radius: Sizes.circularRadius,
                              icon: Iconsax.info_circle_copy, iconColor: Theme.of(context).primaryColor,
                              paddingAll: Sizes.sm,
                            ),
                            SizedBox(width: Sizes.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(aboutTOTP, style: Theme.of(context).textTheme.bodyMedium),
                                  SizedBox(height: Sizes.xs),
                                  Text(totpDes, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
