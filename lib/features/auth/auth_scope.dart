import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/data_sources/firebase_auth_data_source.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/reload_auth_user.dart';
import 'domain/usecases/sign_out.dart';
import 'domain/usecases/watch_auth_state.dart';
import 'presentation/cubits/auth/auth_cubit.dart';

/// Wires the authentication dependencies of the application.
///
/// The project does not use a dependency injection container: providers from
/// `flutter_bloc` are the composition root, exactly like `LanguageCubit` in
/// `main.dart`. Screens create their own form cubits from the
/// [AuthRepository] provided here.
///
/// The optional [repository] parameter exists so widget tests can inject a fake
/// implementation and run without a Firebase project.
class AuthScope extends StatelessWidget {
  const AuthScope({super.key, required this.child, this.repository});

  final Widget child;
  final AuthRepository? repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (_) =>
          repository ??
          FirebaseAuthRepository(FirebaseAuthDataSource(FirebaseAuth.instance)),
      child: BlocProvider<AuthCubit>(
        create: (context) {
          final authRepository = context.read<AuthRepository>();
          return AuthCubit(
            watchAuthState: WatchAuthState(authRepository),
            reloadAuthUser: ReloadAuthUser(authRepository),
            signOut: SignOut(authRepository),
          );
        },
        child: child,
      ),
    );
  }
}
