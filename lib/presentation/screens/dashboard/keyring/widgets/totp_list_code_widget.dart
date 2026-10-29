import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../../core/common_widgets/icon_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../domain/repositories/totp/totp_repository.dart';
import '../../../../bloc/keyring/keyring_bloc.dart';
import '../../../../bloc/keyring/keyring_state.dart';
import '../../../../cubit/totp/totp_cubit.dart';
import '../../../../cubit/totp/totp_state.dart';

class TotpListCodeWidget extends StatelessWidget {
  final String secretKey;
  final String keyringCategoryId;

  const TotpListCodeWidget({
    super.key,
    required this.secretKey,
    required this.keyringCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('$keyringCategoryId-$secretKey'),
      create: (context) => TotpCubit(
        repository: context.read<TotpRepository>(),
        interval: context.read<KeyringBloc>().state.interval,
        secretKey: secretKey,
      )..start(keyringCategoryId: keyringCategoryId),
      child: _TotpListCodeView(
        keyringCategoryId: keyringCategoryId,
      ),
    );
  }
}

class _TotpListCodeView extends StatelessWidget {
  final String keyringCategoryId;

  const _TotpListCodeView({
    required this.keyringCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<KeyringBloc, KeyringState>(
      listenWhen: (previous, current) =>
      previous.interval != current.interval,
      listener: (context, state) {
        context.read<TotpCubit>().updateInterval(
          interval: state.interval,
          keyringCategoryId: keyringCategoryId,
        );
      },
      child: BlocBuilder<TotpCubit, TotpState>(
        builder: (context, state) {
          final interval = context.watch<KeyringBloc>().state.interval;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        state.errorMessage ??
                            (state.otpCode.length == 6
                                ? '${state.otpCode.substring(0, 3)} '
                                '${state.otpCode.substring(3)}'
                                : '------'),
                        style: Theme.of(context)
                            .textTheme.headlineMedium
                            ?.copyWith(
                          fontSize: Sizes.fontSizeLg,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: state.errorMessage != null
                              ? Theme.of(context).colorScheme.error
                              : AppColors.lightGreen
                        ),
                      ),
                    ),
                    SizedBox(width: Sizes.sm),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconWidget(
                            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                            radius: Sizes.circularRadius,
                            icon: Iconsax.copy_copy,
                            iconColor: Theme.of(context).primaryColor,
                            iconSize: Sizes.iconSm,
                            paddingAll: Sizes.sm,
                            onTap: () {
                              if (state.otpCode.length == 6) {
                                Clipboard.setData(
                                  ClipboardData(text: state.otpCode),
                                );
                              }
                            },
                          ),

                          SizedBox(width: Sizes.md),

                          SizedBox(
                            width: Sizes.xl - 4,
                            height: Sizes.xl - 4,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: Sizes.xl - 4,
                                  height: Sizes.xl - 4,
                                  child: CircularProgressIndicator(
                                    value: interval > 0
                                        ? (state.remainingSeconds / interval)
                                        .clamp(0.0, 1.0)
                                        : 0,
                                    strokeWidth: 4,
                                    backgroundColor: AppColors.greyShade,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      state.remainingSeconds <= 10
                                          ? AppColors.orange
                                          : AppColors.lightGreen!,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${state.remainingSeconds}',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: state.remainingSeconds.toString().length > 4
                                          ? Sizes.fontSizeXs - 4
                                          : Sizes.fontSizeXs - 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}