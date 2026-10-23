import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/OnBoarding/onBoarding_tabs.dart';
import 'package:movies_app/Ui/auth/auth_scope.dart';
import 'package:movies_app/Ui/screens/auth/auth_gate.dart';
import 'package:movies_app/Ui/screens/auth/login_screen.dart';
import 'package:movies_app/Ui/screens/auth/new_password_screen.dart';
import 'package:movies_app/Ui/screens/auth/register_screen.dart';
import 'package:movies_app/Ui/screens/reset_password/reset_password_screen.dart';
import 'package:movies_app/Ui/screens/update_profile/update_profile_screen.dart';
import 'package:movies_app/cubit/language/language_cubit.dart';
import 'package:movies_app/cubit/onboarding/onboarding_cubit.dart';
import 'package:movies_app/firebase_options.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_prefs.dart';
import 'package:movies_app/utils/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    BlocProvider(
      create: (_) => LanguageCubit(),
      child: const AuthScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        initialRoute: AppPrefs.onboardingSeen
            ? AppRoutes.homeRouteName
            : AppRoutes.onBoardingRouteName,
        routes: {
          AppRoutes.homeRouteName: (context) => const AuthGate(),
          AppRoutes.onBoardingRouteName: (context) => BlocProvider(
            create: (_) => OnboardingCubit(),
            child: const OnboardingTabs(),
          ),
          AppRoutes.loginRouteName: (context) => const LoginScreen(),
          AppRoutes.registerRouteName: (context) => const RegisterScreen(),
          AppRoutes.forgotPasswordRouteName: (context) =>
              const ResetPasswordScreen(),
          AppRoutes.updateProfileRouteName: (context) =>
              const UpdateProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.newPasswordRouteName) {
            final code = settings.arguments;
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) =>
                  NewPasswordScreen(oobCode: code is String ? code : ''),
            );
          }
          return null;
        },
      ),
    );
  }
}
