import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/screens/home/tabs/browsing_tab/browsing_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/profile_tab/profile_tab.dart';
import 'package:movies_app/Ui/screens/home/tabs/search_tab/search_tab.dart';

import '../../../cubit/home/home_cubit.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/size_utils.dart';
import 'home_bottom_navbar.dart';
import 'tabs/home_tab/home_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _tabs = [
    HomeTab(),
    SearchTab(),
    BrowsingTab(),
    ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, int>(
        builder: (context, selectedIndex) => Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: IndexedStack(index: selectedIndex, children: _tabs),
          bottomNavigationBar: HomeNavigationBar(selectedIndex: selectedIndex),
        ),
      ),
    );
  }
}


