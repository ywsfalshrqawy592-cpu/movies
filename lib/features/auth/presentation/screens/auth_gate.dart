import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/screens/home/home_screen.dart';

import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';
import 'auth_loading_screen.dart';
import 'email_verification_screen.dart';
import 'login_screen.dart';

/// Root of the authenticated area of the app.
///
/// The gate is the single place that decides which screen the user sees based
/// on the real provider session, which prevents duplicated navigation logic
/// (and duplicated navigation events) in the forms.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          // A session can end while a protected screen is pushed on top of the
          // gate (profile, registration, ...): close them so no protected page
          // stays visible after sign-out.
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      builder: (context, state) => switch (state.status) {
        AuthStatus.unknown => const AuthLoadingScreen(),
        AuthStatus.unauthenticated => const LoginScreen(),
        AuthStatus.emailNotVerified => const EmailVerificationScreen(),
        AuthStatus.authenticated => const HomeScreen(),
      },
    );
  }
}
