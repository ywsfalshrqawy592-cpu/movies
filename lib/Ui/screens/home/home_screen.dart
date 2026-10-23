import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/cubits/auth_cubit.dart';
import 'package:movies_app/Ui/screens/home/tabs/browsing_tab/browsing_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/home_tab/home_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/profile_tab/profile_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/search_tab/search_tab.dart';
import 'package:movies_app/cubit/home/home_cubit.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';

import 'home_bottom_navbar.dart';

/// Movie browsing home for an authenticated user, with account actions.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tabs = [HomeTab(), SearchTab(), BrowsingTab(), ProfileTab()];

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
            child: Text(l10n.authCancel, style: AppStyles.bold14White),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.authLogout, style: AppStyles.bold14Primary),
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

    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, selectedIndex) => Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
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
          body: IndexedStack(index: selectedIndex, children: _tabs),
          bottomNavigationBar: HomeNavigationBar(selectedIndex: selectedIndex),
        ),
      ),
    );
  }
}
