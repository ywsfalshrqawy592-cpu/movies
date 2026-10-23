import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_messages.dart';
import 'package:movies_app/Ui/auth/auth_validators.dart';
import 'package:movies_app/Ui/auth/cubits/auth_cubit.dart';
import 'package:movies_app/Ui/auth/cubits/register_cubit.dart';
import 'package:movies_app/Ui/widgets/auth/auth_field_defaults.dart';
import 'package:movies_app/Ui/widgets/auth/auth_form_message.dart';
import 'package:movies_app/Ui/widgets/auth/auth_header.dart';
import 'package:movies_app/Ui/widgets/auth/auth_page_scaffold.dart';
import 'package:movies_app/Ui/widgets/auth/password_field.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/Ui/widgets/custom_text_field.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';

/// Account creation screen.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => RegisterCubit(context.read<AuthCubit>().service),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await context.read<RegisterCubit>().submit(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  /// Closes this screen after a successful registration.
  ///
  /// The account is signed in but unverified, so the gate behind this route
  /// now displays the verification screen: popping back to it is enough.
  void _onRegistrationSucceeded() =>
      Navigator.of(context).popUntil((route) => route.isFirst);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageScaffold(
      title: l10n.authRegisterTitle,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>
            previous.status != current.status && current.isSuccess,
        listener: (context, state) => _onRegistrationSucceeded(),
        builder: (context, state) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeader(
                title: l10n.authRegisterTitle,
                subtitle: l10n.authRegisterSubtitle,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                hintText: l10n.authNameHint,
                labelText: l10n.authNameLabel,
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AuthFieldDefaults.iconColor,
                ),
                style: AuthFieldDefaults.textStyle,
                hintStyle: AuthFieldDefaults.hintStyle,
                labelStyle: AuthFieldDefaults.labelStyle,
                filled: true,
                fillColor: AuthFieldDefaults.fillColor,
                borderColor: AuthFieldDefaults.borderColor,
                validator: (value) {
                  final error = AuthValidators.validateName(value);
                  return error == null
                      ? null
                      : AuthMessages.nameError(l10n, error);
                },
              ),
              const SizedBox(height: 16),
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
                label: l10n.authConfirmPasswordLabel,
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
              const SizedBox(height: 16),
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
                  l10n.authRegisterButton,
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
                  Text(
                    l10n.authHaveAccount,
                    style: AuthFieldDefaults.hintStyle,
                  ),
                  TextButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => Navigator.maybePop(context),
                    child: Text(
                      l10n.authSignIn,
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
