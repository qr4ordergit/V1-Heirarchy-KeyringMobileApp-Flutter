import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/common_widgets/icon_widget.dart';
import 'package:keyring/core/common_widgets/no_data_found_widget.dart';
import 'package:keyring/core/config/app_config.dart';
import 'package:keyring/core/constants/app_colors.dart';
import 'package:keyring/core/device/device_utility.dart';
import 'package:keyring/core/enums/enums.dart';
import 'package:keyring/core/routes/app_routes.dart';
import 'package:keyring/core/services/sheet_service.dart';
import 'package:keyring/core/storage/local_storage_service.dart';
import 'package:keyring/core/storage/storage_keys.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_event.dart';
import 'package:keyring/presentation/screens/settings/notifications/widgets/notification_widget.dart';
import 'package:keyring/presentation/screens/settings/widgets/settings_widget.dart';
import '../../../../core/common_widgets/text_form_field_widget.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../bloc/keyring/keyring_state.dart';
import 'widgets/totp_list_code_widget.dart';

class KeyringScreen extends StatefulWidget {
  const KeyringScreen({super.key});

  @override
  State<KeyringScreen> createState() => _KeyringScreenState();
}

class _KeyringScreenState extends State<KeyringScreen> {
  late final KeyringBloc _keyringBloc;
  late final LocalStorageService _localStorageService;
  final _searchCtr = TextEditingController();


  @override
  void initState() {
    super.initState();
    _keyringBloc = context.read<KeyringBloc>();
    _localStorageService = context.read<LocalStorageService>();
    initCall();
  }

  void initCall() {
    _keyringBloc.add(LoadSavedIntervalEvent());
    _keyringBloc.add(GetKeyringDetailsEvent());
  }

  void _onSearch(String value) {
    context.read<KeyringBloc>().add(KeyringCategorySearchEvent(value));
  }

  @override
  void dispose() {
    super.dispose();
    // _tracker.isKeyringScreen = false;
    _searchCtr.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconWidget(
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              radius: Sizes.borderRadiusLg,
              icon: Iconsax.security_copy,
              iconColor: AppColors.light,
              paddingAll: Sizes.sm,
              borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
            SizedBox(width: Sizes.sm),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm - 1)),
                  if(_localStorageService.getString(StorageKeys.targetUserId) != null)
                    Text(_localStorageService.getString(StorageKeys.targetUserId)!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs - 1), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconWidget(
              icon: Iconsax.setting_copy,
            paddingAll: Sizes.md,
            onTap: () => SheetService.showMaterialBottomSheet(context, child: SettingsWidget()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
          onPressed: () => initCall(),
          child: Icon(Iconsax.refresh_circle_copy)
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.sm),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<KeyringBloc, KeyringState>(
                // buildWhen: (previous, current) {
                //   return previous.apiStatus != current.apiStatus ||
                //       previous.keyringData != current.keyringData ||
                //       previous.errorMessage != current.errorMessage;
                // },
                builder: (context, state) {
                  if(state.apiStatus == ApiStatus.loading || state.intervalStatus == ApiStatus.loading) {
                    return Center(child: DeviceUtility.loadingWidget());
                  }

                  if(state.apiStatus == ApiStatus.failure) {
                    return NoDataFoundWidget(message: state.errorMessage.toString(), showImage: true, onRetry: initCall);
                  }

                  if(state.intervalStatus == ApiStatus.failure) {
                    return NoDataFoundWidget(message: state.intervalMessage.toString(), showImage: true, onRetry: initCall);
                  }

                  if(state.apiStatus == ApiStatus.success) {
                    final keyringList = state.keyringData;

                    return Column(
                      children: [

                        NotificationWidget(),

                        TextFormFieldWidget(
                          controller: _searchCtr,
                          prefixIcon: Iconsax.search_normal_copy,
                          hintText: searchKeyringCategory,
                          onChanged: _onSearch,
                          height: Sizes.lg * 2 - 5,
                        ),

                        SizedBox(height: Sizes.md),

                        Expanded(
                          child: ListView.builder(
                            itemCount: keyringList.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final keyring = keyringList[index];
                              final bool is2Factor = keyring.twoFa == true && keyring.secretKey != null;

                              return Padding(
                                padding: EdgeInsets.only(bottom: Sizes.md - 4),
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    AppRoutes.keyringDetails,
                                    arguments: {
                                      'keyringData': keyring,
                                    },
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: Sizes.md, horizontal: Sizes.sm),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: is2Factor
                                            ? [
                                          const Color(0xFF111B27),
                                          const Color(0xFF101B24),
                                          const Color(0xFF123027),
                                        ]
                                            : [
                                          const Color(0xFF151A27),
                                          const Color(0xFF101521),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: is2Factor
                                            ? const Color(0xFF064B40).withValues(alpha: 0.7)
                                            : AppColors.greyShade,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconWidget(
                                              backgroundColor: is2Factor ? AppColors.green.withValues(alpha: 0.15) : Theme.of(context).primaryColor.withValues(alpha: 0.2),
                                              radius: Sizes.borderRadiusLg,
                                              icon: is2Factor ? Iconsax.lock_copy : Iconsax.key_copy,
                                              iconColor: is2Factor ? AppColors.lightGreen : AppColors.light,
                                              paddingAll: Sizes.md - 2,
                                              iconSize: Sizes.iconSm,
                                              borderColor: is2Factor ? AppColors.lightGreen :  Theme.of(context).primaryColor.withValues(alpha: 0.3),
                                            ),

                                            SizedBox(width: Sizes.sm),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(keyring.keyringCategoryName.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: Sizes.fontSizeXs + 1)),
                                                  SizedBox(height: Sizes.xs/2),
                                                  Text(
                                                    is2Factor
                                                        ? '• $encryptedTwoFa'
                                                        : keyring.keyringCategoryPasswords!.length <= 1
                                                        ? '${keyring.keyringCategoryPasswords!.length} $password'
                                                        : '${keyring.keyringCategoryPasswords!.length} $passwords',
                                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontSize: Sizes.fontSizeXs - 1,
                                                      color: is2Factor
                                                          ? Color.lerp(AppColors.green, Colors.white, 0.4)
                                                          : Theme.of(context).colorScheme.primary,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  )
                                                ],
                                              ),
                                            ),
                                            IconWidget(
                                              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                                              radius: Sizes.circularRadius,
                                              icon: Iconsax.arrow_right_3_copy,
                                              iconColor: AppColors.light,
                                              paddingAll: Sizes.xs,
                                              iconSize: Sizes.iconSm - 1,
                                              borderColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                                            ),
                                            // IconWidget(icon: Iconsax.arrow_circle_right_copy, paddingAll: Sizes.xs)
                                          ],
                                        ),

                                        if (is2Factor) ...[

                                          SizedBox(height: Sizes.xs),
                                          DeviceUtility.divider(color: AppColors.greyShade),
                                          TotpListCodeWidget(
                                            key: ValueKey(keyring.id),
                                            secretKey: keyring.secretKey!,
                                            keyringCategoryId: keyring.id!,
                                          ),
                                        ],

                                        // SizedBox(height: Sizes.sm),
                                        // Align(
                                        //     alignment: Alignment.bottomRight,
                                        //     child: Text(DateFormatter.formatDate(keyring.createdOn.toString()), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs - 2), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                        // ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
