import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';

/// Default colors and text styles of the authentication form fields.
///
/// The values mirror the design used by the existing screens so the flow looks
/// identical wherever it is opened from.
class AuthFieldDefaults {
  const AuthFieldDefaults._();

  static const Color fillColor = AppColors.darkFieldColor;

  static const Color borderColor = AppColors.transparentColor;

  static const Color iconColor = AppColors.whiteColor;

  static const TextStyle textStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 16,
  );

  static const TextStyle hintStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 14,
  );

  static const TextStyle labelStyle = TextStyle(
    color: AppColors.whiteColor,
    fontSize: 14,
  );
}
