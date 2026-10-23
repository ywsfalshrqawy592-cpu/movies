import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../utils/size_utils.dart';

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
          style: AppStyles.regular14White,
          children: [
            TextSpan(text: '$question '),
            TextSpan(
              text: action,
              style: AppStyles.bold14Primary,
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
    final width = context.width;
    final line = SizedBox(
      width: width * 0.214,
      child: Divider(color: AppColors.primaryColor, thickness: 1),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.026),
          child: Text(
            'OR',
            style: AppStyles.regular15Primary,
          ),
        ),
        line,
      ],
    );
  }
}
