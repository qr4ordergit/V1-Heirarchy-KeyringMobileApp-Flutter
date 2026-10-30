import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/routes/app_routes.dart';
import '../../../core/common_widgets/button_widget.dart';
import '../../../core/common_widgets/icon_widget.dart';
import '../../../core/common_widgets/no_data_found_widget.dart';
import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/device/device_utility.dart';
import '../../../core/enums/enums.dart';
import '../../../core/formatters/date_formatter.dart';
import '../../../core/services/sheet_service.dart';
import '../../../core/utils/icon_utils.dart';
import '../../bloc/device/device_bloc.dart';
import '../../bloc/device/device_event.dart';
import '../../bloc/device/device_state.dart';
import '../settings/widgets/settings_widget.dart';

class DevicesScreen extends StatefulWidget {
  final bool isNavigate;

  const DevicesScreen({
    super.key,
    this.isNavigate = true,
  });

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  late final DeviceBloc _deviceBloc;

  @override
  void initState() {
    super.initState();
    _deviceBloc = context.read<DeviceBloc>();
    _deviceBloc.add(InitDevicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(manageDevices),
        actions: [
          IconWidget(
            onTap: () => SheetService.showMaterialBottomSheet(context, child: SettingsWidget()),
            icon: Iconsax.setting_copy,
            paddingRight: Sizes.md,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _deviceBloc.add(InitDevicesEvent()),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.sm),
          child: Column(
            children: [
              BlocConsumer<DeviceBloc, DeviceState>(
                listener: (context, state) {
                  if(widget.isNavigate && state.isUnderLimit && state.loadingStatus == LoadingStatus.success) {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.keyring,
                    );
                  }

                  if(state.authType == AuthType.logout && state.actionLoadingStatus == LoadingStatus.success) {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.signIn,
                            (route) => false
                    );
                  }
                },
                builder: (context, state) {

                  if(widget.isNavigate && state.isUnderLimit && state.loadingStatus == LoadingStatus.success) {
                    return SizedBox.shrink();
                  }

                  if(state.loadingStatus == LoadingStatus.loading) {
                    return Center(child: DeviceUtility.loadingWidget());
                  }

                  if(state.loadingStatus == LoadingStatus.failure) {
                    return Center(child: NoDataFoundWidget(message: state.errorMessage.toString(), showImage: true));
                  }

                  if(state.loadingStatus == LoadingStatus.success) {
                    final deviceModel = state.deviceModel;
                    final devices = deviceModel?.deviceList ?? [];

                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(Sizes.md) ,
                            margin: EdgeInsets.only(bottom: Sizes.md),
                            decoration: BoxDecoration(
                              color: state.isUnderLimit == true ? Theme.of(context).primaryColor.withValues(alpha: 0.3) : AppColors.red.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconWidget(
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.4),
                                  radius: Sizes.borderRadiusMd,
                                  icon: Iconsax.mobile_copy,
                                  iconColor: state.isUnderLimit == true ? Color.lerp(Theme.of(context).primaryColor, AppColors.light, 0.4) : Color.lerp(AppColors.red, AppColors.light, 0.4),
                                  paddingAll: Sizes.md,
                                ),
                                SizedBox(width: Sizes.sm),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(state.isUnderLimit ? deviceLimitAvailable : deviceLimitReached, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                        Text(state.isUnderLimit ? deviceLimitAvailableDescription : deviceLimitReachedDescription, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: Sizes.fontSizeXs - 1)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: Sizes.md),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(signedInDevices, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeXs + 1)),
                              Text(devices.length > 1 ? '${devices.length} $sessions' : '${devices.length} $session', maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeXs + 1)),
                            ],
                          ),

                          SizedBox(height: Sizes.sm),

                          Expanded(
                            child: ListView.builder(
                              itemCount: devices.length,
                              itemBuilder: (context, index) {
                                final device = devices[index];
                                final isLogoutLoading = state.selectedDeviceId == device.id && state.actionLoadingStatus == LoadingStatus.loading;

                                return Container(
                                  padding: EdgeInsets.all(Sizes.md) ,
                                  margin: EdgeInsets.only(bottom: Sizes.md),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IconWidget(
                                        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.4),
                                        radius: Sizes.borderRadiusMd,
                                        icon: IconUtils.getDeviceIcon(device.platform),
                                        iconColor: Theme.of(context).primaryColor,
                                        iconSize: Sizes.iconMd - 2,
                                        paddingAll: Sizes.md - 4,
                                      ),

                                      SizedBox(width: Sizes.sm),

                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(device.deviceName.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeXs + 1)),
                                            SizedBox(height: Sizes.xs),
                                            Row(
                                              children: [
                                                Flexible(child: Text(device.platform.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs - 1))),
                                                SizedBox(width: Sizes.xs),
                                                Flexible(
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: Sizes.xs - 2, horizontal: Sizes.sm),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.green.withValues(alpha: 0.2),
                                                      borderRadius: BorderRadius.circular(Sizes.borderRadiusMd),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Center(child: Text(active, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Sizes.fontSizeXs - 3, color: AppColors.green))),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: Sizes.xs),
                                            Row(
                                              children: [
                                                Icon(Iconsax.clock_copy, size: Sizes.iconSm - 2, color: AppColors.grey),
                                                SizedBox(width: Sizes.xs),
                                                Expanded(child: Text("$signedIn ${DateFormatter.formatRelativeTime(device.createdAt?.date)}", maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs - 1))),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          ButtonWidget(
                                            label: logout,
                                              icon: Iconsax.login_copy,
                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                              radius: Sizes.borderRadiusMd,
                                              iconColor: AppColors.red,
                                              textColor: Color.lerp(AppColors.red, AppColors.light, 0.4),
                                              isLoading: isLogoutLoading,
                                              onPressed: ()=> _deviceBloc.add(LogoutSpecificDeviceEvent(sessionId: device.id!))
                                          )
                                          // IconWidget(
                                          //     icon: Iconsax.login_copy,
                                          //     paddingAll: Sizes.sm + 1,
                                          //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                          //     radius: Sizes.circularRadius,
                                          //     iconColor: Color.lerp(AppColors.red, AppColors.light, 0.4),
                                          //     isLoading: isLogoutLoading,
                                          //     onTap: ()=> _deviceBloc.add(LogoutSpecificDeviceEvent(sessionId: device.id!))
                                          // )
                                        ],
                                      ),

                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          Row(
                            children: [
                              if(state.deviceModel?.deviceList?.length != 0)
                                Expanded(
                                child: ButtonWidget(
                                    label: logoutAllDevices,
                                    icon: Iconsax.login_copy,
                                    backgroundColor: Colors.transparent,
                                    borderColor: Color.lerp(AppColors.red, AppColors.light, 0.4),
                                    radius: Sizes.circularRadius,
                                    iconColor: AppColors.red,
                                    textColor: Color.lerp(AppColors.red, AppColors.light, 0.4),
                                    isLoading: state.authType == AuthType.logout && state.actionLoadingStatus == LoadingStatus.loading,
                                    onPressed: ()=> _deviceBloc.add(LogoutAllDeviceEvent())
                                ),
                              ),


                              if(state.isUnderLimit && state.deviceModel?.deviceList?.length != 0)
                                ...[
                                  SizedBox(width: Sizes.sm),
                                  Expanded(
                                    child: ButtonWidget(
                                      label: dashboard,
                                      onPressed: () => Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.keyring,
                                      ),
                                    ),
                                  ),
                                ]

                            ],
                          )

                        ],
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}
