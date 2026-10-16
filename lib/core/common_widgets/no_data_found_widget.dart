import 'package:flutter/material.dart';
import 'package:keyring/core/common_widgets/button_widget.dart';
import '../config/app_config.dart';
import '../constants/app_assets.dart';
import '../constants/app_sizes.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String message;
  final bool? showImage;
  final void Function()? onRetry;
  const NoDataFoundWidget({super.key, required this.message, this.showImage = false, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if(showImage == true) Image.asset(AppAssets.emptyImg),
          Text(message,textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: Sizes.fontSizeXs)),

          if(onRetry != null)
          ButtonWidget(
            label: retry,
            onPressed: onRetry,
          )
        ],
      ),
    );
  }
}
