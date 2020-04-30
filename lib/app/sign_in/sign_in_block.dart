import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:track_time/services/auth.dart';

class SignInManager {
  SignInManager({@required this.isLoading, @required this.auth});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInWithGoogle() => _signIn(auth.signInWithGoogle);
  Future<User> signInAnonymously() => _signIn(auth.signInAnonymously);
}
