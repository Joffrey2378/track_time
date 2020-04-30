import 'package:flutter/material.dart';
import 'package:track_time/common_widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton(
      {@required String text,
      @required String assetsName,
      Color textColor,
      Color color,
      VoidCallback onPressed})
      : assert(assetsName != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(assetsName),
              Text(
                text,
                style: TextStyle(color: textColor, fontSize: 15.0),
              ),
              Opacity(
                child: Image.asset(assetsName),
                opacity: 0.0,
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
