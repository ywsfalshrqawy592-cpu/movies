import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

/// Inline message shown under a form: failure or success feedback.
class AuthFormMessage extends StatelessWidget {
  const AuthFormMessage({super.key, required this.text, this.isError = true});

  final String text;

  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            size: 18,
            color: isError ? AppColors.redColor : AppColors.primaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppStyles.bold14White.copyWith(
                fontWeight: FontWeight.normal,
                color: isError ? AppColors.redColor : AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
