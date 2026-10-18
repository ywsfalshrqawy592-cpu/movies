import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/Ui/widgets/custom_text_field.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:movies_app/features/auth/domain/validation/auth_validators.dart';
import 'package:movies_app/features/auth/presentation/helpers/auth_messages.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_field_defaults.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_form_message.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:movies_app/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:movies_app/features/auth/presentation/widgets/password_field.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';

import '../cubits/login/login_cubit.dart';
import '../cubits/login/login_state.dart';

/// Email + password login screen.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        signInWithEmail: SignInWithEmail(context.read<AuthRepository>()),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await context.read<LoginCubit>().submit(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _openForgotPassword() =>
      Navigator.of(context).pushNamed(AppRoutes.forgotPasswordRouteName);

  void _openRegistration() =>
      Navigator.of(context).pushNamed(AppRoutes.registerRouteName);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageScaffold(
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: l10n.authLoginTitle,
                subtitle: l10n.authLoginSubtitle,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                hintText: l10n.authEmailHint,
                labelText: l10n.authEmailLabel,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AuthFieldDefaults.iconColor,
                ),
                style: AuthFieldDefaults.textStyle,
                hintStyle: AuthFieldDefaults.hintStyle,
                labelStyle: AuthFieldDefaults.labelStyle,
                filled: true,
                fillColor: AuthFieldDefaults.fillColor,
                borderColor: AuthFieldDefaults.borderColor,
                validator: (value) {
                  final error = AuthValidators.validateEmail(value);
                  return error == null
                      ? null
                      : AuthMessages.emailError(l10n, error);
                },
              ),
              const SizedBox(height: 16),
              PasswordField(
                controller: _passwordController,
                label: l10n.authPasswordLabel,
                hint: l10n.authPasswordHint,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (value) {
                  // Only the empty case is enforced here: Firebase is the
                  // authority on whether the credentials are correct.
                  if ((value ?? '').isEmpty) {
                    return l10n.authErrorPasswordRequired;
                  }
                  return null;
                },
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: state.isSubmitting ? null : _openForgotPassword,
                  child: Text(
                    l10n.authForgotPassword,
                    style: AuthFieldDefaults.hintStyle.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              if (state.hasFailed)
                AuthFormMessage(
                  text: AuthMessages.failure(l10n, state.failure!),
                ),
              const SizedBox(height: 8),
              CustomElevatedBotton(
                onPressed: _submit,
                isLoading: state.isSubmitting,
                padding: 16,
                child: Text(
                  l10n.authLoginButton,
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.authNoAccount, style: AuthFieldDefaults.hintStyle),
                  TextButton(
                    onPressed: state.isSubmitting ? null : _openRegistration,
                    child: Text(
                      l10n.authSignUp,
                      style: AuthFieldDefaults.textStyle.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
