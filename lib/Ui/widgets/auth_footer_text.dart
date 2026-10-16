import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

/// "Don't Have Account ? Create One" style line.
class AuthFooterText extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback? onTap;

  const AuthFooterText({
    super.key,
    required this.question,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 14, color: AppColors.whiteColor),
          children: [
            TextSpan(text: '$question '),
            TextSpan(
              text: action,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ———— OR ———— divider.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const line = SizedBox(
      width: 92,
      child: Divider(color: AppColors.primaryColor, thickness: 1),
    );
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 11),
          child: Text(
            'OR',
            style: TextStyle(color: AppColors.primaryColor, fontSize: 15),
          ),
        ),
        line,
      ],
    );
  }
}
