import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_messages.dart';
import 'package:movies_app/Ui/auth/auth_validators.dart';
import 'package:movies_app/Ui/auth/cubits/auth_cubit.dart';
import 'package:movies_app/Ui/auth/cubits/new_password_cubit.dart';
import 'package:movies_app/Ui/widgets/auth/auth_form_message.dart';
import 'package:movies_app/Ui/widgets/auth/auth_header.dart';
import 'package:movies_app/Ui/widgets/auth/auth_page_scaffold.dart';
import 'package:movies_app/Ui/widgets/auth/password_field.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';

/// Completes a password reset from a Firebase reset link.
///
/// Firebase sends the `oobCode` as part of the action link. The route receives
/// that code and verifies it with the provider before asking for the new
/// password, so expired or already used links are rejected by Firebase itself.
class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key, required this.oobCode});

  final String oobCode;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewPasswordCubit>(
      create: (context) =>
          NewPasswordCubit(context.read<AuthCubit>().service, oobCode),
      child: const _NewPasswordView(),
    );
  }
}

class _NewPasswordView extends StatefulWidget {
  const _NewPasswordView();

  @override
  State<_NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<_NewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await context.read<NewPasswordCubit>().submit(_passwordController.text);
  }

  void _backToLogin() =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageScaffold(
      title: l10n.authNewPasswordTitle,
      child: BlocBuilder<NewPasswordCubit, NewPasswordState>(
        builder: (context, state) {
          if (state.isVerifying) {
            return const Padding(
              padding: EdgeInsets.only(top: 64),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              ),
            );
          }

          if (state.hasInvalidLink) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  title: l10n.authNewPasswordTitle,
                  subtitle: l10n.authResetLinkProblemBody,
                ),
                const SizedBox(height: 24),
                AuthFormMessage(
                  text: AuthMessages.failure(l10n, state.failure!),
                ),
                const SizedBox(height: 8),
                CustomElevatedBotton(
                  onPressed: () => Navigator.maybePop(context),
                  padding: 16,
                  child: Text(
                    l10n.authRequestNewResetLink,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          }

          if (state.isSuccess) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Icon(
                  Icons.check_circle_outline,
                  size: 96,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.authNewPasswordSuccess,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                CustomElevatedBotton(
                  onPressed: _backToLogin,
                  padding: 16,
                  child: Text(
                    l10n.authBackToLogin,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthHeader(
                  title: l10n.authNewPasswordTitle,
                  subtitle: l10n.authNewPasswordBody(state.email ?? ''),
                ),
                const SizedBox(height: 32),
                if (state.hasFailed) ...[
                  AuthFormMessage(
                    text: AuthMessages.failure(l10n, state.failure!),
                  ),
                  const SizedBox(height: 16),
                ],
                PasswordField(
                  controller: _passwordController,
                  label: l10n.authNewPasswordLabel,
                  hint: l10n.authPasswordHint,
                  validator: (value) {
                    final error = AuthValidators.validatePassword(value);
                    return error == null
                        ? null
                        : AuthMessages.passwordError(l10n, error);
                  },
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: _confirmPasswordController,
                  label: l10n.authConfirmNewPasswordLabel,
                  hint: l10n.authConfirmPasswordHint,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    final error = AuthValidators.validateConfirmPassword(
                      value,
                      _passwordController.text,
                    );
                    return error == null
                        ? null
                        : AuthMessages.confirmPasswordError(l10n, error);
                  },
                ),
                const SizedBox(height: 24),
                CustomElevatedBotton(
                  onPressed: _submit,
                  isLoading: state.isSubmitting,
                  padding: 16,
                  child: Text(
                    l10n.authNewPasswordButton,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
