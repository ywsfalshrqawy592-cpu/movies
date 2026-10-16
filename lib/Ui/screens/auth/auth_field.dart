import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/size_utils.dart';
import '../../widgets/custom_text_field.dart';

/// The dark rounded input from the design, built on the team's CustomTextField.
class AuthField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;

  const AuthField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final width = context.width;

    return CustomTextField(
      hintText: hint,
      keyboardType: keyboardType,
      obscureText: isPassword,
      filled: true,
      fillColor: AppColors.fieldColor,
      borderColor: AppColors.fieldColor,
      style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
      hintStyle: TextStyle(color: AppColors.whiteColor, fontSize: 16),
      prefixIcon: Icon(icon, color: AppColors.whiteColor, size: width * 0.065),
      suffixIcon: isPassword
          ? Icon(
              Icons.visibility_off,
              color: AppColors.whiteColor,
              size: width * 0.06,
            )
          : null,
    );
  }
}
