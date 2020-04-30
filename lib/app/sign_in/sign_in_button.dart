import 'package:flutter/material.dart';
import 'package:track_time/common_widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton(
      {@required String text,
      Color textColor,
      Color color,
      VoidCallback onPressed})
      : assert(text != null),
        super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          onPressed: onPressed,
        );
}
