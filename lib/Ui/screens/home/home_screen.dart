import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/screens/home/tabs/browsing_tab/browsing_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/home_tab/home_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/profile_tab/profile_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/search_tab/search_tab.dart';
import 'package:movies_app/cubit/home/home_cubit.dart';
import 'package:movies_app/utils/app_colors.dart';

import 'home_bottom_navbar.dart';

/// Movie browsing home for an authenticated user, with account actions.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tabs = [HomeTab(), SearchTab(), BrowsingTab(), ProfileTab()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, selectedIndex) => Scaffold(
          backgroundColor: AppColors.backgroundColor,
          extendBody: true,
          body: SafeArea(
            child: IndexedStack(index: selectedIndex, children: _tabs),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: HomeNavigationBar(selectedIndex: selectedIndex),
          ),
        ),
      ),
    );
  }
}
