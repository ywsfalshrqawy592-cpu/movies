import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
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
    return CustomTextField(
      hintText: hint,
      keyboardType: keyboardType,
      obscureText: isPassword,
      filled: true,
      fillColor: AppColors.fieldColor,
      borderColor: AppColors.fieldColor,
      style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
      hintStyle: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
      prefixIcon: Icon(icon, color: AppColors.whiteColor, size: 28),
      suffixIcon: isPassword
          ? const Icon(Icons.visibility_off, color: AppColors.whiteColor)
          : null,
    );
  }
}
