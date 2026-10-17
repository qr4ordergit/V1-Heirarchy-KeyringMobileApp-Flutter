import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../../core/common_widgets/icon_widget.dart';
import '../../../../../core/config/app_config.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/enums/enums.dart';
import '../../../../../core/snackbars/snackbars.dart';
import '../../../../bloc/keyring/keyring_bloc.dart';
import '../../../../bloc/keyring/keyring_event.dart';
import '../../../../bloc/keyring/keyring_state.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<KeyringBloc, KeyringState>(
      listenWhen: (prev, curr) => prev.requestStatus != curr.requestStatus && curr.requestStatus == ApiStatus.failure,
      listener: (context, state) {
        SnackBars.snackMessage(context, description: state.actionErrorMessage.toString(), messageType: MessageType.error);
      },
      buildWhen: (prev, curr) =>
      prev.notificationPayloads != curr.notificationPayloads ||
          prev.loadingRequestId != curr.loadingRequestId ||
          prev.loadingIsAccept != curr.loadingIsAccept,
      builder: (context, state) {
        final notifications = state.notificationPayloads;
        if (notifications.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(bottom: Sizes.md),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final p = notifications[index];
              final isThisLoading = state.loadingRequestId == p.requestId;
              final isAcceptLoading = isThisLoading && state.loadingIsAccept == true;
              final isRejectLoading = isThisLoading && state.loadingIsAccept == false;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == notifications.length - 1 ? 0 : Sizes.md,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Sizes.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.keyringCategoryName.toString(),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Sizes.xs / 2),
                            Text(
                              newRequestDes,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: Sizes.fontSizeXs - 1,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: Sizes.xs),
                      IconWidget(
                        backgroundColor: AppColors.green.withValues(alpha: 0.2),
                        radius: Sizes.circularRadius,
                        icon: Iconsax.tick_circle_copy,
                        iconColor: AppColors.green,
                        paddingAll: Sizes.sm,
                        isLoading: isAcceptLoading,
                        onTap: () => context.read<KeyringBloc>().add(
                          AcceptRejectKeyringRequest(
                            requestId: p.requestId ?? '',
                            keyringCategoryId: p.keyringCategoryId ?? '',
                            otp: p.otp ?? '',
                            action: 'accepted',
                          ),
                        ),
                      ),
                      SizedBox(width: Sizes.sm),
                      IconWidget(
                        backgroundColor: AppColors.red.withValues(alpha: 0.2),
                        radius: Sizes.circularRadius,
                        icon: Iconsax.close_circle_copy,
                        iconColor: AppColors.red,
                        paddingAll: Sizes.sm,
                        isLoading: isRejectLoading,
                        onTap:() => context.read<KeyringBloc>().add(
                          AcceptRejectKeyringRequest(
                            requestId: p.requestId ?? '',
                            keyringCategoryId: p.keyringCategoryId ?? '',
                            otp: p.otp ?? '',
                            action: 'rejected',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
