import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:track_time/app/sign_in/email_sign_in_change_model.dart';
import 'package:track_time/common_widgets/form_submit_button.dart';
import 'package:track_time/common_widgets/platform_exception_alert_dialog.dart';
import 'package:track_time/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
          builder: (context, model, _) =>
              EmailSignInFormChangeNotifier(model: model)),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField() {
    return TextField(
      controller: _emailTextEditingController,
      focusNode: _emailFocusNode,
      enabled: !model.isLoading,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      onEditingComplete: () => _onEmailEditingComplete(),
    );
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordTextEditingController,
      focusNode: _passwordFocusNode,
      obscureText: true,
      enabled: !model.isLoading,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
      ),
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  @override
  Widget build(BuildContext context) {
//          final EmailSignInModel model = snapshot.data;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailTextEditingController.clear();
    _passwordTextEditingController.clear();
  }

  void _onEmailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
}
