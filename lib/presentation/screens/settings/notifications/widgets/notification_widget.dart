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


  void _onAcceptReject({required String requestId, required String keyringCategoryId, required bool isAccept}) {
    context.read<KeyringBloc>().add(
        AcceptRejectKeyringRequest(
          requestId: requestId,
          keyringCategoryId: keyringCategoryId,
          action: isAccept ? 'accepted' : 'rejected',
        ));
  }


  @override
  Widget build(BuildContext context) {
    // return BlocConsumer<KeyringBloc, KeyringState>(
    //   listenWhen: (prev, curr) => prev.requestStatus != curr.requestStatus && curr.requestStatus == ApiStatus.failure,
    //   listener: (context, state) {
    //     SnackBars.snackMessage(context, description: state.actionErrorMessage.toString(), messageType: MessageType.error);
    //   },
    //   buildWhen: (prev, curr) =>
    //   prev.notificationPayloads != curr.notificationPayloads ||
    //       prev.loadingRequestId != curr.loadingRequestId ||
    //       prev.loadingIsAccept != curr.loadingIsAccept,
    //   builder: (context, state) {
    //     final notifications = state.notificationPayloads;
    //     if (notifications.isEmpty) return const SizedBox.shrink();
    //
    //
    //     return Container(
    //       padding: EdgeInsets.only(bottom: Sizes.md),
    //       child: ConstrainedBox(
    //         constraints: BoxConstraints(
    //           maxHeight: MediaQuery.sizeOf(context).height * 0.30,
    //         ),
    //         child: ListView.builder(
    //           shrinkWrap: true,
    //           padding: EdgeInsets.zero,
    //           itemCount: notifications.length,
    //           itemBuilder: (context, index) {
    //             final p = notifications[index];
    //             final isThisLoading = state.loadingRequestId == p.requestId;
    //             final isAcceptLoading = isThisLoading && state.loadingIsAccept == true;
    //             final isRejectLoading = isThisLoading && state.loadingIsAccept == false;
    //
    //             return Padding(
    //               padding: EdgeInsets.only(
    //                 bottom: index == notifications.length - 1 ? 0 : Sizes.md,
    //               ),
    //               child: Container(
    //                 width: double.infinity,
    //                 padding: EdgeInsets.all(Sizes.md),
    //                 decoration: BoxDecoration(
    //                   color: Theme.of(context).cardColor,
    //                   borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
    //                 ),
    //                 child: Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             p.keyringCategoryName.toString(),
    //                             style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: Sizes.fontSizeSm),
    //                             maxLines: 3,
    //                             overflow: TextOverflow.ellipsis,
    //                           ),
    //                           SizedBox(height: Sizes.xs / 2),
    //                           Text(
    //                             newRequestDes,
    //                             style: Theme.of(context).textTheme.bodySmall?.copyWith(
    //                               fontWeight: FontWeight.normal,
    //                               fontSize: Sizes.fontSizeXs - 1,
    //                             ),
    //                             maxLines: 3,
    //                             overflow: TextOverflow.ellipsis,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     SizedBox(width: Sizes.xs),
    //                     IconWidget(
    //                       backgroundColor: AppColors.green.withValues(alpha: 0.2),
    //                       radius: Sizes.circularRadius,
    //                       icon: Iconsax.tick_circle_copy,
    //                       iconColor: AppColors.green,
    //                       paddingAll: Sizes.sm,
    //                       isLoading: isAcceptLoading,
    //                       onTap: () => _onAcceptReject(requestId: p.requestId!, keyringCategoryId: p.keyringCategoryId!, isAccept: true),
    //                     ),
    //                     SizedBox(width: Sizes.sm),
    //                     IconWidget(
    //                       backgroundColor: AppColors.red.withValues(alpha: 0.2),
    //                       radius: Sizes.circularRadius,
    //                       icon: Iconsax.close_circle_copy,
    //                       iconColor: AppColors.red,
    //                       paddingAll: Sizes.sm,
    //                       isLoading: isRejectLoading,
    //                       onTap: () => _onAcceptReject(requestId: p.requestId!, keyringCategoryId: p.keyringCategoryId!, isAccept: false),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     );
    //   },
    // );
    return BlocConsumer<KeyringBloc, KeyringState>(
      listenWhen: (previous, current) =>
      previous.requestStatus != current.requestStatus &&
          current.requestStatus == ApiStatus.failure,
      listener: (context, state) {
        SnackBars.snackMessage(
          context,
          description:
          state.actionErrorMessage ?? 'Unable to process request.',
          messageType: MessageType.error,
        );
      },
      buildWhen: (previous, current) =>
      previous.pendingRequests != current.pendingRequests ||
          previous.keyringData != current.keyringData ||
          previous.originalKeyringData != current.originalKeyringData ||
          previous.loadingRequestId != current.loadingRequestId ||
          previous.loadingIsAccept != current.loadingIsAccept,
      builder: (context, state) {
        final requests = state.pendingRequests;

        if (requests!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.only(bottom: Sizes.md),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.30,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: requests!.length,
            itemBuilder: (context, index) {
              final request = requests[index];

              final requestId = request.id;
              final categoryId = request.keyringCategoryId;

              final keyringList = state.keyringData.isNotEmpty
                  ? state.keyringData
                  : state.originalKeyringData;

              final matchingKeyrings = keyringList.where(
                    (keyring) => keyring.id == categoryId,
              );

              final categoryName = matchingKeyrings.isNotEmpty
                  ? matchingKeyrings.first.keyringCategoryName ??
                  'Keyring request'
                  : 'Keyring request';

              final isThisLoading =
                  state.loadingRequestId == requestId;

              final isAcceptLoading =
                  isThisLoading && state.loadingIsAccept == true;

              final isRejectLoading =
                  isThisLoading && state.loadingIsAccept == false;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == requests!.length - 1 ? 0 : Sizes.md,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Sizes.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                      Sizes.borderRadiusLg,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                fontSize: Sizes.fontSizeSm,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: Sizes.xs / 2),
                            Text(
                              '${request.accessUsername ?? 'A user'} is requesting access.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
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
                        backgroundColor:
                        AppColors.green.withValues(alpha: 0.2),
                        radius: Sizes.circularRadius,
                        icon: Iconsax.tick_circle_copy,
                        iconColor: AppColors.green,
                        paddingAll: Sizes.sm,
                        isLoading: isAcceptLoading,
                        onTap: requestId == null || categoryId == null ||
                            isThisLoading
                            ? null
                            : () => _onAcceptReject(
                          requestId: requestId,
                          keyringCategoryId: categoryId,
                          isAccept: true,
                        ),
                      ),
                      SizedBox(width: Sizes.sm),
                      IconWidget(
                        backgroundColor:
                        AppColors.red.withValues(alpha: 0.2),
                        radius: Sizes.circularRadius,
                        icon: Iconsax.close_circle_copy,
                        iconColor: AppColors.red,
                        paddingAll: Sizes.sm,
                        isLoading: isRejectLoading,
                        onTap: requestId == null || categoryId == null ||
                            isThisLoading
                            ? null
                            : () => _onAcceptReject(
                          requestId: requestId,
                          keyringCategoryId: categoryId,
                          isAccept: false,
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
