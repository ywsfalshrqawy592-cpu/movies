import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/size_utils.dart';

class CustomElevatedBotton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? padding;

  /// Replaces [child] with a progress indicator and disables the button.
  ///
  /// Used by the authentication forms to prevent double submissions.
  final bool isLoading;
  final Color? progressIndicatorColor;

  const CustomElevatedBotton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.isLoading = false,
    this.progressIndicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    final buttonColor = backgroundColor ?? AppColors.primaryColor;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            width: 2,
            color: borderColor ?? AppColors.transparentColor,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: padding ?? height * 0.01),
        backgroundColor: buttonColor,
        disabledBackgroundColor: buttonColor.withValues(alpha: 0.5),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: progressIndicatorColor ?? AppColors.blackColor,
              ),
            )
          : child,
    );
  }
}
