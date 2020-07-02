import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:track_time/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:track_time/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(Provider<AuthBase>(
      create: (_) => mockAuth,
      child: MaterialApp(
        home: Scaffold(
          body: EmailSignInFormStateful(
            onSignedIn: onSignedIn,
          ),
        ),
      ),
    ));
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((realInvocation) => Future<User>.value(User(uid: '123')));
  }

  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any)).thenThrow(
        PlatformException(code: 'ERROR_WRONG_CREDS', message: 'sdf'));
  }

  group('Sign in', () {
    testWidgets(
        'WHEN user does not enter the emil and password'
        'AND user taps on Sign in button'
        'THEN createUserWithEmailAndPassword is NOT called'
        'AND user is not signed in', (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final signInButton = find.text('Sign in');
      expect(signInButton, findsOneWidget);

      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets(
        'WHEN user enters a valid email and password'
        'AND user taps on Sign in button'
        'THEN createUserWithEmailAndPassword is called'
        'AND user is signed in', (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordSucceeds();

      const email = 'email@mail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Sign in');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, true);
    });

    testWidgets(
        'WHEN user enters an invalid email and password'
        'AND user taps on Sign in button'
        'THEN signInUserWithEmailAndPassword is NOT called'
        'AND user is not signed in', (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordThrows();

      const email = 'email@mail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Sign in');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, false);
    });
  });

  group('Register', () {
    Future<void> _toggleFormType(WidgetTester tester) async {
      final secondaryButton = find.byType(FlatButton);
      expect(secondaryButton, findsOneWidget);
      await tester.tap(secondaryButton);
      await tester.pump();
    }

    testWidgets(
        'WHEN user taps on secondary button'
        'THEN form toggles to registration mode', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      await _toggleFormType(tester);

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
    });

    testWidgets(
        'WHEN user taps on secondary button'
        'THEN form toggles to registration mode'
        'AND user does not enter an email and password'
        'AND user taps on Create an account'
        'THEN createUserWithEmailAndPassword is not called',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      await _toggleFormType(tester);

      final registerButton = find.text('Create an account');
      expect(registerButton, findsOneWidget);
      await tester.tap(registerButton);
      verifyNever(mockAuth.createUserWithEmailAndPassword(any, any));
    });

    testWidgets(
        'WHEN user taps on secondary button'
        'THEN form toggles to registration mode'
        'AND user enters a valid email and password'
        'AND user taps on Create an account'
        'THEN createUserWithEmailAndPassword is called',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      await _toggleFormType(tester);

      const email = 'email@mail.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Create an account');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
    });
  });
}
