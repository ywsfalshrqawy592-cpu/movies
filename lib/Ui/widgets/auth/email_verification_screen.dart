import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_failure.dart';
import 'package:movies_app/Ui/widgets/auth/auth_messages.dart';
import 'package:movies_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:movies_app/cubit/auth_cubit/email_verification_cubit.dart';
import 'package:movies_app/Ui/widgets/auth/auth_field_defaults.dart';
import 'package:movies_app/Ui/widgets/auth/auth_page_scaffold.dart';
import 'package:movies_app/Ui/widgets/custom_elevated_botton.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

/// Screen shown while the email address of the user is not verified yet.
///
/// It only ever reads the verification state from the provider: pressing the
/// button here cannot mark an email as verified.
class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmailVerificationCubit>(
      create: (context) =>
          EmailVerificationCubit(context.read<AuthCubit>().service),
      child: const _EmailVerificationView(),
    );
  }
}

class _EmailVerificationView extends StatefulWidget {
  const _EmailVerificationView();

  @override
  State<_EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<_EmailVerificationView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // The verification link is opened outside of the app (browser / mail app).
    // Reloading when the app comes back is what turns the real provider flag
    // into the next screen.
    if (state == AppLifecycleState.resumed) {
      context.read<AuthCubit>().refreshUser();
    }
  }

  Future<void> _checkVerification() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final authCubit = context.read<AuthCubit>();

    final verified = await authCubit.refreshUser();
    if (!mounted) return;

    final failure = authCubit.state.refreshFailure;
    final message = switch (verified) {
      true => l10n.authEmailVerified,
      false => l10n.authStillNotVerified,
      // The provider could not be reached: show the real reason (offline,
      // rate limited, ...) instead of a generic message.
      null =>
        failure == null
            ? l10n.authErrorUnexpected
            : AuthMessages.failure(l10n, failure),
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signOut() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final authCubit = context.read<AuthCubit>();

    try {
      await authCubit.signOut();
    } on AuthFailure {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.authErrorUnexpected)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AuthPageScaffold(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 96,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.authEmailVerificationTitle,
              textAlign: TextAlign.center,
              style: AppStyles.bold24White,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.authEmailVerificationSentTo(authState.user?.email ?? ''),
              textAlign: TextAlign.center,
              style: AppStyles.bold16White.copyWith(
                fontWeight: FontWeight.normal,
                color: AppColors.grayColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.authEmailVerificationSpamHint,
              textAlign: TextAlign.center,
              style: AuthFieldDefaults.hintStyle.copyWith(
                color: AppColors.grayColor,
              ),
            ),
            const SizedBox(height: 32),
            BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                final messenger = ScaffoldMessenger.of(context);
                switch (state.status) {
                  case EmailVerificationStatus.sent:
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.authVerificationEmailSent)),
                    );
                  case EmailVerificationStatus.failure:
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          AuthMessages.failure(l10n, state.failure!),
                        ),
                      ),
                    );
                  case EmailVerificationStatus.idle:
                  case EmailVerificationStatus.sending:
                    break;
                }
              },
              builder: (context, state) => CustomElevatedBotton(
                backgroundColor: AppColors.blackColor,
                borderColor: AppColors.primaryColor,
                onPressed: state.canResend
                    ? () => context.read<EmailVerificationCubit>().resendEmail()
                    : null,
                isLoading: state.isSending,
                padding: 16,
                child: Text(
                  state.cooldownSeconds > 0
                      ? l10n.authResendVerificationEmailIn(
                          state.cooldownSeconds,
                        )
                      : l10n.authResendVerificationEmail,
                  style: AppStyles.bold16White.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            CustomElevatedBotton(
              onPressed: _checkVerification,
              isLoading: authState.isRefreshing,
              padding: 16,
              child: Text(
                l10n.authIVerifiedMyEmail,
                style: const TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _signOut,
              child: Text(
                l10n.authUseAnotherAccount,
                style: AuthFieldDefaults.textStyle.copyWith(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
