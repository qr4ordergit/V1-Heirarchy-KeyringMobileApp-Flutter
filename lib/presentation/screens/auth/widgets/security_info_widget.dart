import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../core/common_widgets/icon_widget.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class SecurityInfoWidget extends StatelessWidget {
  const SecurityInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Sizes.md),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconWidget(
            backgroundColor: Color.lerp(AppColors.green, AppColors.light, 0.6),
            radius: Sizes.circularRadius,
            icon: Iconsax.shield_tick_copy, iconColor: AppColors.dark,
            paddingAll: Sizes.sm,
          ),
          SizedBox(width: Sizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(secure, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm)),
                SizedBox(height: Sizes.xs),
                Text(secureDes, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.normal, fontSize: Sizes.fontSizeXs)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
