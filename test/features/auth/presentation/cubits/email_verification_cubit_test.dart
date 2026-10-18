import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/features/auth/domain/failures/auth_failure.dart';
import 'package:movies_app/features/auth/domain/usecases/send_email_verification.dart';
import 'package:movies_app/features/auth/presentation/cubits/email_verification/email_verification_cubit.dart';
import 'package:movies_app/features/auth/presentation/cubits/email_verification/email_verification_state.dart';

import '../../fakes/fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late EmailVerificationCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = EmailVerificationCubit(
      sendEmailVerification: SendEmailVerification(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.dispose();
  });

  test('sends the verification email and starts the cooldown', () async {
    await cubit.resendEmail();

    expect(cubit.state.status, EmailVerificationStatus.sent);
    expect(repository.sendEmailVerificationCalls, 1);
    expect(
      cubit.state.cooldownSeconds,
      EmailVerificationCubit.resendCooldownSeconds,
    );
    expect(cubit.state.canResend, isFalse);
  });

  test('ignores a second request during the cooldown', () async {
    await cubit.resendEmail();
    await cubit.resendEmail();

    expect(repository.sendEmailVerificationCalls, 1);
  });

  test('slows down further attempts when the provider rate limits', () async {
    repository.sendEmailVerificationFailure = const AuthFailure(
      AuthFailureType.tooManyRequests,
    );

    await cubit.resendEmail();

    expect(cubit.state.status, EmailVerificationStatus.failure);
    expect(cubit.state.failure?.type, AuthFailureType.tooManyRequests);
    expect(cubit.state.canResend, isFalse);
  });

  test('reports offline failures without starting the cooldown', () async {
    repository.sendEmailVerificationFailure = const AuthFailure(
      AuthFailureType.networkError,
    );

    await cubit.resendEmail();

    expect(cubit.state.status, EmailVerificationStatus.failure);
    expect(cubit.state.cooldownSeconds, 0);
    expect(cubit.state.canResend, isTrue);
  });

  test('clears the previous failure on a new attempt', () async {
    repository.sendEmailVerificationFailure = const AuthFailure(
      AuthFailureType.networkError,
    );
    await cubit.resendEmail();
    expect(cubit.state.failure, isNotNull);

    repository.sendEmailVerificationFailure = null;
    await cubit.resendEmail();

    expect(cubit.state.failure, isNull);
    expect(cubit.state.status, EmailVerificationStatus.sent);
  });
}
