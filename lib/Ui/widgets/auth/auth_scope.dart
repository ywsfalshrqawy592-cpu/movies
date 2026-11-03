import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_service.dart';
import 'package:movies_app/cubit/auth_cubit/auth_cubit.dart';

/// Wires the authentication service and the session cubit of the application.
///
/// The project does not use a dependency injection container: providers from
/// `flutter_bloc` are the composition root, exactly like `LanguageCubit` in
/// `main.dart`. Screens create their form cubits from the service exposed by
/// [AuthCubit].
///
/// The optional [service] parameter exists so widget tests can inject a fake
/// implementation and run without a Firebase project.
class AuthScope extends StatelessWidget {
  const AuthScope({super.key, required this.child, this.service});

  final Widget child;
  final AuthService? service;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(service ?? AuthService()),
      child: child,
    );
  }
}
