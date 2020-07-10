import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:track_time/app/sign_in/sign_in_block.dart';
import 'package:track_time/services/auth.dart';

import 'mocks.dart';

class MockValueNotifier<T> extends ValueNotifier<T> {
  MockValueNotifier(T value) : super(value);

  List<T> values = [];

  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  MockAuth mockAuth;
  MockValueNotifier<bool> isLoading;
  SignInManager manager;

  setUp(() {
    mockAuth = MockAuth();
    isLoading = MockValueNotifier<bool>(false);
    manager = SignInManager(isLoading: isLoading, auth: mockAuth);
  });

  test('sign-in - success', () async {
    when(mockAuth.signInAnonymously())
        .thenAnswer((_) => Future.value(User(uid: '123')));
    await manager.signInAnonymously();
    expect(isLoading.values, [true]);
  });

  test('sign-in - failure', () async {
    when(mockAuth.signInAnonymously()).thenThrow(PlatformException(
      code: 'SOME_ERROR',
      message: 'sign-in-error',
      details: 'Called for sign-in failure test',
    ));
    try {
      await manager.signInAnonymously();
    } catch (e) {
      expect(isLoading.values, [true, false]);
    }
  });
}
