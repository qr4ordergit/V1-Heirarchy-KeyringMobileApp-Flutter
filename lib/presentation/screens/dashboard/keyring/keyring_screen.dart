import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/common_widgets/icon_widget.dart';
import 'package:keyring/core/common_widgets/no_data_found_widget.dart';
import 'package:keyring/core/config/app_config.dart';
import 'package:keyring/core/constants/app_colors.dart';
import 'package:keyring/core/device/device_utility.dart';
import 'package:keyring/core/enums/enums.dart';
import 'package:keyring/core/formatters/date_formatter.dart';
import 'package:keyring/core/routes/app_routes.dart';
import 'package:keyring/core/storage/local_storage_service.dart';
import 'package:keyring/core/storage/storage_keys.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_event.dart';
import '../../../../core/common_widgets/text_form_field_widget.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../bloc/keyring/keyring_state.dart';

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
    _keyringBloc.add(GetKeyringDetailsEvent());
  }

  void _onSearch(String value) {
    context.read<KeyringBloc>().add(KeyringCategorySearchEvent(value));
  }

  @override
  void dispose() {
    super.dispose();
    _searchCtr.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm - 1)),
            if(_localStorageService.getString(StorageKeys.targetUserId) != null)
              Text(_localStorageService.getString(StorageKeys.targetUserId)!, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs - 1), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
        actions: [
          BlocConsumer<AuthBloc, AuthState>(
            listener: (previous, current) {
              if(current is LogoutSuccess || current is LogoutFailure) {
                // Clears ALL routes from the history stack
                Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.signIn,
                        (route) => false
                );
              }
            },
            builder: (context, state) {
              return IconWidget(
                icon: Iconsax.login_copy,
                paddingAll: Sizes.md,
                isLoading: state is LogoutLoading,
                onTap: state is LogoutLoading ? null : ()=> context.read<AuthBloc>().add(LogoutRequestEvent()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
          onPressed: () => initCall(),
          child: Icon(Iconsax.refresh_circle_copy)
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.sm),
        child: BlocBuilder<KeyringBloc, KeyringState>(
          buildWhen: (previous, current) {
            return previous.apiStatus != current.apiStatus ||
                previous.keyringData != current.keyringData ||
                previous.errorMessage != current.errorMessage;
          },
          builder: (context, state) {
            if(state.apiStatus == ApiStatus.loading) {
              return Center(child: DeviceUtility.loadingWidget());
            }

            if(state.apiStatus == ApiStatus.failure) {
              return NoDataFoundWidget(message: state.errorMessage.toString(), showImage: true, onRetry: initCall);
            }

            if(state.apiStatus == ApiStatus.success) {
              final keyringList = state.keyringData;

              return Column(
                children: [

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
                          padding: EdgeInsets.only(bottom: Sizes.md),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.keyringDetails, arguments: keyring),
                            child: Container(
                              padding: EdgeInsets.all(Sizes.sm),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  // border: Border.all(color: AppColors.greyShade),
                                  borderRadius: BorderRadius.circular(Sizes.borderRadiusLg)
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      IconWidget(
                                        backgroundColor: keyring.twoFa == true ? Color.lerp(AppColors.green, Colors.white, 0.2) : Theme.of(context).primaryColor,
                                        radius: Sizes.circularRadius,
                                        icon: keyring.twoFa == true ? Iconsax.lock_copy : Iconsax.key_copy, iconColor: AppColors.dark,
                                        paddingAll: Sizes.sm,
                                        iconSize: Sizes.iconSm,
                                      ),

                                      SizedBox(width: Sizes.sm),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(keyring.keyringCategoryName.toString(), maxLines: 2, overflow: TextOverflow.ellipsis,),
                                            SizedBox(height: Sizes.xs/2),
                                            Text(is2Factor ? encrypted$TwoFa: keyring.keyringCategoryPasswords!.length <= 1 ? '${keyring.keyringCategoryPasswords!.length} $password' : '${keyring.keyringCategoryPasswords!.length} $passwords', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs - 1), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                          ],
                                        ),
                                      ),
                                      IconWidget(icon: Iconsax.arrow_circle_right_copy, paddingAll: Sizes.xs)
                                    ],
                                  ),
                                  SizedBox(height: Sizes.sm),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(DateFormatter.formatDate(keyring.createdOn.toString()), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs - 2), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                  ),
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
    );
  }
}
