import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/routes/app_routes.dart';
import 'package:keyring/presentation/screens/dashboard/keyring/widgets/set_interval_widget.dart';

import '../../../../core/common_widgets/app_list_tile.dart';
import '../../../../core/common_widgets/icon_widget.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/device/device_utility.dart';
import '../../../../core/services/sheet_service.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';

class SettingsWidget extends StatelessWidget {
  final bool? isShowLogout;
  const SettingsWidget({super.key, this.isShowLogout = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(settings, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Sizes.fontSizeSm, fontWeight: FontWeight.w600)),
            IconWidget(
              icon: Iconsax.arrow_circle_down_copy,
              onTap: () => Navigator.pop(context),
              paddingRight: Sizes.sm,
            ),

          ],
        ),
        SizedBox(height: Sizes.sm/2),
        DeviceUtility.divider(),


        AppListTile(
          title: setInterval,
          subtitle: setIntervalSub,
          maxLines: 2,
          onTap: () {
            Navigator.pop(context);
            SheetService.showMaterialBottomSheet(
              context,
              isDismissible: false,
              child: SetIntervalWidget(),
            );
          },
          leading: Icon(Iconsax.message_copy, color: Theme.of(context).primaryColor),
        ),

        AppListTile(
          leading: Icon(Iconsax.mobile_copy, color: Theme.of(context).primaryColor),
          title: manageDevices,
          subtitle: manageDevicesSub,
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.devices,
            arguments: {
              'isNavigate': false,
            },
          ),
          maxLines: 2,
        ),

        if(isShowLogout == true)
          BlocConsumer<AuthBloc, AuthState>(
            listener: (previous, current) {
              if(current is LogoutSuccess || current is LogoutFailure) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                    AppRoutes.signIn,
                    (route) => false
                );
              }
            },
            builder: (context, state) {
              return AppListTile(
                leading: Icon(Iconsax.login_copy, color: Theme.of(context).primaryColor),
                title: logout,
                subtitle: logoutSub,
                trailing: state is LogoutLoading ? DeviceUtility.loadingWidget() : Icon(Iconsax.arrow_circle_right_copy) ,
                onTap: state is LogoutLoading ? null : ()=> context.read<AuthBloc>().add(LogoutRequestEvent()),
              );
            },
          ),

      ],
    );
  }
}
