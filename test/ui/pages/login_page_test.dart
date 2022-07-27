import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tdd_study/ui/pages/pages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;
  StreamController<String> emailErrorController;
  StreamController<String> passwordErrorController;
  StreamController<bool> ifFormValidController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = LoginPresenterSpy();
    emailErrorController = StreamController<String>();
    passwordErrorController = StreamController<String>();
    ifFormValidController = StreamController<bool>();
    when(presenter.emailErrorStream).thenAnswer(
      (realInvocation) => emailErrorController.stream,
    );
    when(presenter.passwordErrorStream).thenAnswer(
      (realInvocation) => passwordErrorController.stream,
    );
    when(presenter.isFormValidStream).thenAnswer(
      (realInvocation) => ifFormValidController.stream,
    );
    final loginPage = MaterialApp(
      home: LoginPage(presenter: presenter),
    );
    await tester.pumpWidget(loginPage);
  }

  tearDown(() {
    emailErrorController.close();
    passwordErrorController.close();
    ifFormValidController.close();
  });

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

  testWidgets(
    "Sould present error if email is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    "Sould present no error if email is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(null);
      await tester.pump();

      final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel("Email"),
        matching: find.byType(Text),
      );

      expect(
        emailTextChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Sould present error if password is invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('any error');
      await tester.pump();

      expect(find.text('any error'), findsOneWidget);
    },
  );

  testWidgets(
    "Sould present no error if password is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(null);
      await tester.pump();

      final passwordChildren = find.descendant(
        of: find.bySemanticsLabel("Senha"),
        matching: find.byType(Text),
      );

      expect(
        passwordChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Sould present no error if password is valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add('');
      await tester.pump();

      final passwordChildren = find.descendant(
        of: find.bySemanticsLabel("Senha"),
        matching: find.byType(Text),
      );

      expect(
        passwordChildren,
        findsOneWidget,
      );
    },
  );

  testWidgets(
    "Sould enable button is form valid",
    (WidgetTester tester) async {
      await loadPage(tester);

      ifFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNotNull);
    },
  );

  testWidgets(
    "Sould not enable button is form invalid",
    (WidgetTester tester) async {
      await loadPage(tester);

      ifFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    },
  );
}
