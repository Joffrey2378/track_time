import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EntriesListTileModel {
  final String leadingText;
  final String trailingText;
  final String middleText;
  final bool isHeader;

  const EntriesListTileModel({
    @required this.leadingText,
    @required this.trailingText,
    this.middleText,
    this.isHeader = false,
  });
}

class EntriesListTile extends StatelessWidget {
  final EntriesListTileModel model;

  const EntriesListTile({@required this.model});

  @override
  Widget build(BuildContext context) {
    const fontSize = 16.0;
    return Container(
      color: model.isHeader ? Colors.indigo[100] : null,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Text(model.leadingText, style: TextStyle(fontSize: fontSize)),
          Expanded(child: Container()),
          if (model.middleText != null)
            Text(
              model.middleText,
              style: TextStyle(color: Colors.green[700], fontSize: fontSize),
              textAlign: TextAlign.right,
            ),
          SizedBox(
            width: 60.0,
            child: Text(
              model.trailingText,
              style: TextStyle(fontSize: fontSize),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
