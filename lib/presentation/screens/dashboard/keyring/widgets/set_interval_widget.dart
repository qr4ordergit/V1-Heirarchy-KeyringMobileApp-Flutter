import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:keyring/core/common_widgets/button_widget.dart';
import 'package:keyring/core/common_widgets/text_form_field_widget.dart';
import 'package:keyring/core/enums/enums.dart';
import 'package:keyring/core/snackbars/snackbars.dart';
import 'package:keyring/core/storage/local_storage_service.dart';
import 'package:keyring/core/storage/storage_keys.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_bloc.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_event.dart';
import 'package:keyring/presentation/bloc/keyring/keyring_state.dart';
import '../../../../../core/common_widgets/icon_widget.dart';
import '../../../../../core/config/app_config.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/device/device_utility.dart';

class SetIntervalWidget extends StatefulWidget {
  const SetIntervalWidget({super.key});

  @override
  State<SetIntervalWidget> createState() => _SetIntervalWidgetState();
}

class _SetIntervalWidgetState extends State<SetIntervalWidget> {
  final _intervalCtr = TextEditingController();

  late final KeyringBloc _keyringBloc;
  late final LocalStorageService _localStorageService;

  @override
  void initState() {
    super.initState();
    _keyringBloc = context.read<KeyringBloc>();
    _localStorageService = context.read<LocalStorageService>();
    // _keyringBloc.add(GetIntervalEvent());

    final savedInterval = _localStorageService.getInt(StorageKeys.interval);
    if(savedInterval != null) {
      _intervalCtr.text = savedInterval.toString();
    }
  }

  void _onSubmit() {
    if(_intervalCtr.text.trim().isEmpty) return;

    _keyringBloc.add(UpdateIntervalEvent(interval: int.parse(_intervalCtr.text)));
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              setInterval,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: Sizes.fontSizeSm,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconWidget(
              icon: Iconsax.arrow_circle_down_copy,
              onTap: () => Navigator.pop(context),
              paddingRight: Sizes.sm,
            ),
          ],
        ),
        SizedBox(height: Sizes.sm / 2),
        DeviceUtility.divider(),
        Text(setIntervalSub, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs)),

        SizedBox(height: Sizes.md),


        BlocConsumer<KeyringBloc, KeyringState>(
          listener: (context, state) {
            if (state.intervalStatus == ApiStatus.success) {
              _intervalCtr.text = state.interval.toString();
            }

            // if(state.intervalStatus == ApiStatus.failure || state.intervalUpdateStatus == ApiStatus.failure) {
            //   SnackBars.snackMessage(context, description: state.intervalMessage.toString(), messageType: MessageType.error);
            // }

            if(state.intervalUpdateStatus == ApiStatus.failure) {
              SnackBars.snackMessage(context, description: state.intervalMessage.toString(), messageType: MessageType.error);
            }

            if(state.intervalUpdateStatus == ApiStatus.success) {
              SnackBars.snackMessage(context, description: state.intervalMessage.toString(), messageType: MessageType.success);
              Navigator.pop(context);
            }
          },
            builder: (context, state) {
              // if (state.intervalStatus == ApiStatus.loading) {
              //   return Center(child: DeviceUtility.loadingWidget());
              // }

            // if(state.intervalStatus == ApiStatus.success) {

              return Column(
                children: [
                  TextFormFieldWidget(
                    controller: _intervalCtr,
                    prefixIcon: Iconsax.clock_copy,
                    hintText: enterInterval,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) => (value == null || value.isEmpty) ? enterInterval : null,
                  ),

                  SizedBox(height: Sizes.md),

                  Center(
                    child: ButtonWidget(
                      label: update,
                      icon: Iconsax.tick_circle_copy,
                      isLoading: state.intervalUpdateStatus == ApiStatus.loading,
                      onPressed: _onSubmit,
                    ),
                  ),
                ],
              );
            // }
            // return SizedBox.shrink();

            }
        ),

        SizedBox(height: Sizes.md),

      ],
    );
  }
}
