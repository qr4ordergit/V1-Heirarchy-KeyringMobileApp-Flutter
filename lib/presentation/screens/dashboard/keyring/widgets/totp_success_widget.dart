import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/common_widgets/icon_widget.dart';
import '../../../../../core/config/app_config.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

class TotpSuccessWidget extends StatelessWidget {
  const TotpSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconWidget(
          backgroundColor: AppColors.green.withValues(alpha: 0.2),
          radius: Sizes.circularRadius,
          icon: Iconsax.verify_copy, iconColor: AppColors.green,
          paddingAll: Sizes.sm,
        ),
        SizedBox(width: Sizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(passwordVerified, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm)),
              SizedBox(width: Sizes.xs),
              Text(passwordVerifiedDes, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: Sizes.fontSizeXs)),
            ],
          ),
        )
      ],
    );
  }
}
