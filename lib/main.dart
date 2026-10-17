import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movies_app/Ui/OnBoarding/onboarding_cubit.dart';
import 'package:movies_app/Ui/language/language_cubit.dart';
import 'package:movies_app/Ui/screens/home/home_screen.dart';
import 'package:movies_app/utils/app_prefs.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'Ui/OnBoarding/onBoarding_tabs.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  //await AppPrefs.setLanguageCode('ar');
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (_) => LanguageCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: AppPrefs.onboardingSeen
              ? AppRoutes.homeRouteName
              : AppRoutes.onBoardingRouteName,
          routes: {
            AppRoutes.homeRouteName: (context) => const HomeScreen(),
            AppRoutes.onBoardingRouteName: (context) => BlocProvider(
              create: (_) => OnboardingCubit(),
              child: const OnboardingTabs(),
            ),
          },
        );
      },
    );
  }
}