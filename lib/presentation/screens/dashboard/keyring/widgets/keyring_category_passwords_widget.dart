import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/common_widgets/icon_widget.dart';
import 'package:keyring/core/constants/app_colors.dart';
import 'package:keyring/core/constants/app_sizes.dart';
import 'package:keyring/core/device/device_utility.dart';

import '../../../../../core/common_widgets/app_avatar_widget.dart';
import '../../../../../core/common_widgets/app_list_tile.dart';
import '../../../../../data/models/keyring/keyring_model.dart';

class KeyringCategoryPasswordsWidget extends StatelessWidget {
  final KeyringData keyring;
  const KeyringCategoryPasswordsWidget({super.key, required this.keyring});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizes.sm),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: keyring.keyringCategoryPasswords!.length,
        separatorBuilder: (_,_) => DeviceUtility.divider(),
        itemBuilder: (context, index) {
          final entry = keyring.keyringCategoryPasswords!.entries.elementAt(index);
          return AppListTile(
            leading: AppAvatar(
              fallbackText: "${index + 1}",
            ),
            title: entry.key,
            subtitle: entry.value,
            contentPadding: 0,
            minTileHeight: Sizes.md,
            visualDensity: VisualDensity.compact,
            trailing: IconWidget(
              paddingAll: Sizes.sm,
              icon: Iconsax.copy_copy,
              onTap: () => Clipboard.setData(ClipboardData(text: entry.value)
              ),
            ),
          );
        },
      ),
    );
  }
}
