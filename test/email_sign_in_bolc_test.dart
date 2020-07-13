import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:track_time/app/sign_in/email_sign_in_bloc.dart';
import 'package:track_time/app/sign_in/email_sign_in_model.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  EmailSignInBloc bloc;

  setUp(() {
    mockAuth = MockAuth();
    bloc = EmailSignInBloc(auth: mockAuth);
  });

  tearDown(() {
    bloc.dispose();
  });

  test(
      'WHEN email is updated'
      'AND password is updated'
      'AND submit is called'
      'THEN modelStream emits correct events', () async {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(code: 'ERROR', message: 'throw-error'));

    expect(
        bloc.modelStream,
        emitsInOrder([
          EmailSignInModel(),
          EmailSignInModel(email: 'email@email.com'),
          EmailSignInModel(
            email: 'email@email.com',
            password: 'password',
          ),
          EmailSignInModel(
            email: 'email@email.com',
            password: 'password',
            isLoading: true,
            submitted: true,
          ),
          EmailSignInModel(
            email: 'email@email.com',
            password: 'password',
            isLoading: false,
            submitted: true,
          )
        ]));

    bloc.updateEmail('email@email.com');

    bloc.updatePassword('password');

    expect(
        bloc.modelStream,
        emits(EmailSignInModel(
          email: 'email@email.com',
          password: 'password',
        )));

    try {
      await bloc.submit();
    } catch (_) {}
  });
}
