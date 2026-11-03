import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

/// Shown while the session is being restored at startup.
///
/// It replaces the "nothing to show yet" gap so the app never displays an empty
/// black screen before we know whether a user is signed in.
class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.branding, height: 140, fit: BoxFit.contain),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.primaryColor),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: AppStyles.bold16White,
            ),
          ],
        ),
      ),
    );
  }
}
