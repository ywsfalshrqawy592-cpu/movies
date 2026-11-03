import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

/// Title and optional subtitle shown on an authentication screen.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppAssets.splash,
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        Text(title, textAlign: TextAlign.center, style: AppStyles.bold24White),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: AppStyles.bold16White.copyWith(
              color: AppColors.grayColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }
}
