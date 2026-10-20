import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/Ui/screens/auth/login_screen.dart';
import 'package:movies_app/main.dart';

import 'features/auth/fakes/fake_auth_service.dart';
import 'helpers/pump_app.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    final repository = FakeAuthService();
    addTearDown(repository.dispose);

    await pumpAuthApp(tester, repository);

    expect(find.byType(MyApp), findsOneWidget);
    // A visitor without a session always starts on the login screen.
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
