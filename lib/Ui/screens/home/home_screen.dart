import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/presentation/cubits/auth/auth_cubit.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';

/// Home screen of the signed-in user.
///
/// Only the authentication integration (profile / logout actions) is added
/// here; the movie content is still owned by the rest of the team.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();
    final messenger = ScaffoldMessenger.of(context);

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkFieldColor,
        title: Text(l10n.authLogout, style: AppStyles.bold20White),
        content: Text(
          l10n.authLogoutConfirmBody,
          style: AppStyles.bold14White.copyWith(fontWeight: FontWeight.normal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              l10n.authCancel,
              style: const TextStyle(color: AppColors.whiteColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              l10n.authLogout,
              style: const TextStyle(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    try {
      // The gate moves back to the login screen as soon as the session ends.
      await authCubit.signOut();
    } on AuthFailure {
      messenger.showSnackBar(SnackBar(content: Text(l10n.authErrorUnexpected)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.darkBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.appTitle, style: AppStyles.bold20Primary),
        actions: [
          IconButton(
            tooltip: l10n.authEditProfile,
            icon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryColor,
            ),
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.updateProfileRouteName),
          ),
          IconButton(
            tooltip: l10n.authLogout,
            icon: const Icon(Icons.logout, color: AppColors.primaryColor),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}
