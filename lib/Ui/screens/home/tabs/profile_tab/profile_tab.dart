import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_failure.dart';
import 'package:movies_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkFieldColor,
        title: Text(l10n.authLogout),
        content: Text(l10n.authLogoutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.authCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.authLogout),
          ),
        ],
      ),
    );
    if (shouldLogout != true) return;
    try {
      await authCubit.signOut();
    } on AuthFailure {
      messenger.showSnackBar(SnackBar(content: Text(l10n.authErrorUnexpected)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<AuthCubit>().state.user;
    final name = user?.displayName?.trim();
    final photoUrl = user?.photoUrl;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.fieldColor,
              backgroundImage: photoUrl == null ? null : AssetImage(photoUrl),
              child: photoUrl == null
                  ? const Icon(
                      Icons.person_outline,
                      size: 48,
                      color: AppColors.primaryColor,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            if (name != null && name.isNotEmpty)
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (user?.email != null) ...[
              const SizedBox(height: 8),
              Text(
                user!.email!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grayColor),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.updateProfileRouteName),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.authEditProfile),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _confirmLogout(context),
              icon: const Icon(Icons.logout),
              label: Text(l10n.authLogout),
            ),
          ],
        ),
      ),
    );
  }
}
