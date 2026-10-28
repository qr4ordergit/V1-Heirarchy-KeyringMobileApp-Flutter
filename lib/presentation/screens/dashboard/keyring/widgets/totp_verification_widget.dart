import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/common_widgets/button_widget.dart';
import '../../../../../core/common_widgets/icon_widget.dart';
import '../../../../../core/config/app_config.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../bloc/keyring/keyring_bloc.dart';
import '../../../../bloc/keyring/keyring_event.dart';

class TotpVerificationWidget extends StatelessWidget {
  final String keyringCategoryId;
  final bool isLoading;
  final String otpCode;
  final String? errorMessage;

  const TotpVerificationWidget({
    super.key,
    required this.keyringCategoryId,
    required this.isLoading,
    this.otpCode = "",
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconWidget(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          radius: Sizes.circularRadius,
          icon: Iconsax.shield_tick_copy, iconColor: Theme.of(context).primaryColor,
          paddingAll: Sizes.sm,
        ),
        SizedBox(width: Sizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getPasswords, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm)),
              SizedBox(width: Sizes.xs),
              Text(getPasswordDes, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs)),
              SizedBox(height: Sizes.xs),
              ButtonWidget(
                onPressed: otpCode.length != 6 || errorMessage != null ? null : () {
                  context.read<KeyringBloc>().add(
                    GetKeyringPasswordEvent(
                      keyringCategoryId: keyringCategoryId,
                      otp: otpCode,
                    ),
                  );
                },
                isLoading: isLoading,
                label: verify,
                icon: Iconsax.tick_circle_copy,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
