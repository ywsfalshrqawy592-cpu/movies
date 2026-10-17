import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movies_app/cubit/onboarding/onboarding_cubit.dart';
import 'package:movies_app/Ui/screens/home/home_screen.dart';
import 'package:movies_app/Ui/screens/auth/login_screen.dart';
import 'package:movies_app/Ui/screens/auth/register_screen.dart';
import 'package:movies_app/utils/app_prefs.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'Ui/OnBoarding/onBoarding_tabs.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // initialRoute: AppPrefs.onboardingSeen
      //     ? AppRoutes.loginRouteName
      //     : AppRoutes.onBoardingRouteName,
      initialRoute: AppRoutes.homeRouteName,
      routes: {
        AppRoutes.homeRouteName: (context) => const HomeScreen(),
        AppRoutes.loginRouteName: (context) => const LoginScreen(),
        AppRoutes.registerRouteName: (context) => const RegisterScreen(),
        AppRoutes.onBoardingRouteName: (context) => BlocProvider(
          create: (_) => OnboardingCubit(),
          child: const OnboardingTabs(),
        ),
      },
      // locale: Locale(), // todo: we will use the language bloc here
    );
  }
}