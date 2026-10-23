import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_messages.dart';
import 'package:movies_app/Ui/auth/auth_validators.dart';
import 'package:movies_app/Ui/auth/cubits/auth_cubit.dart';
import 'package:movies_app/Ui/auth/cubits/forgot_password_cubit.dart';
import 'package:movies_app/Ui/widgets/auth/auth_form_message.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/Ui/widgets/custom_text_field.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';

/// مسار صورة الشاشة. صدّرها من Figma (الفريم 430x430) باسم
/// forget_password.png وحطها في assets/images
const String kForgetPasswordImage = 'assets/images/forget_password.png';

/// bg و field مش موجودين في AppColors، فسيبتهم هنا.
/// لو حاتم اضافهم، استبدلهم بـ AppColors.
/// (تمت إضافة darkBackgroundColor و darkFieldColor في AppColors، والقيم
/// المحلية هنا متروكة كما هي للحفاظ على شكل الشاشة.)
class _C {
  static const bg = Color(0xFF121312);
  static const field = Color(0xFF282A28);
  static const primary = AppColors.primaryColor;
  static const white = AppColors.whiteColor;
}

/// Requests a password reset link from Firebase Authentication.
///
/// The success message is neutral so the screen cannot be used to find out
/// whether an account exists for an email address.
class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordCubit>(
      create: (context) =>
          ForgotPasswordCubit(context.read<AuthCubit>().service),
      child: const _ResetPasswordView(),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView();

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await context.read<ForgotPasswordCubit>().submit(_emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _C.bg,
      appBar: AppBar(
        backgroundColor: _C.bg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _C.primary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          l10n.authForgotPasswordTitle,
          style: const TextStyle(color: _C.primary, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          builder: (context, state) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    kForgetPasswordImage,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.authForgotPasswordBody,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _C.white, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    onChange: (_) =>
                        context.read<ForgotPasswordCubit>().clearResult(),
                    hintText: l10n.authEmailLabel,
                    hintStyle: const TextStyle(color: _C.white, fontSize: 14),
                    prefixIcon: const Icon(Icons.email, color: _C.white),
                    style: const TextStyle(color: _C.white, fontSize: 16),
                    filled: true,
                    fillColor: _C.field,
                    borderColor: AppColors.transparentColor,
                    validator: (value) {
                      final error = AuthValidators.validateEmail(value);
                      return error == null
                          ? null
                          : AuthMessages.emailError(l10n, error);
                    },
                  ),
                  const SizedBox(height: 16),
                  if (state.hasFailed)
                    AuthFormMessage(
                      text: AuthMessages.failure(l10n, state.failure!),
                    ),
                  if (state.isSuccess)
                    AuthFormMessage(
                      text: l10n.authResetLinkSent,
                      isError: false,
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedBotton(
                      backgroundColor: _C.primary,
                      padding: 16,
                      isLoading: state.isSubmitting,
                      onPressed: _submit,
                      child: Text(
                        l10n.authSendResetLink,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
