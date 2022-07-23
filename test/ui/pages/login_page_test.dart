import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    final loginPage = MaterialApp(
      home: LoginPage(presenter: presenter),
    );
    await tester.pumpWidget(loginPage);
  }

  testWidgets(
    "Should load with correct initial state",
    (WidgetTester tester) async {
      await loadPage(tester);

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel("Email"),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
        reason:
            "when a TextFormField has only one text child, means it has no error, since one of the childs is always the hint text",
      );

      final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel("Senha"),
        matching: find.byType(Text),
      );

      expect(
        passwordTextChildren,
        findsOneWidget,
        reason:
            "when a TextFormField has only one text child, means it has no error, since one of the childs is always the hint text",
      );

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, null);
    },
  );

  testWidgets(
    "Sould call validate with correct values",
    (WidgetTester tester) async {
      await loadPage(tester);

      final email = faker.internet.email();
      await tester.enterText(find.bySemanticsLabel("Email"), email);
      verify(presenter.validateEmail(email));

      final password = faker.internet.password();
      await tester.enterText(find.bySemanticsLabel("Senha"), password);
      verify(presenter.validatePassword(password));
    },
  );
}
