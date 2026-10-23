import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/widgets/auth/auth_validators.dart';

void main() {
  test('accepts a valid email', () {
    expect(AuthValidators.validateEmail('user@example.com'), isNull);
  });

  test('accepts a valid password', () {
    expect(AuthValidators.validatePassword('Movie123'), isNull);
  });
}
