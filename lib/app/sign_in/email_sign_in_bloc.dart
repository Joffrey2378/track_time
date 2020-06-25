import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:track_time/app/sign_in/email_sign_in_model.dart';
import 'package:track_time/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final _modelSubject =
      BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());
  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() => _modelSubject.close();

  Future<void> submit() async {
    updateWith(
      submitted: true,
      isLoading: true,
    );
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith(
      {String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool submitted}) {
//    _modelSubject.value = _model.copyWith( //This is the same as below
    _modelSubject.add(_model.copyWith(
      email: email,
      password: password,
      formType: formType,
      submitted: submitted,
      isLoading: isLoading,
    ));
  }
}
