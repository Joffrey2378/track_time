import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:track_time/common_widgets/custom_raised_button.dart';

void main() {
  testWidgets('first widget test', (WidgetTester tester) async {
    var pressed = false;
    await tester.pumpWidget(MaterialApp(
        home: CustomRaisedButton(
      child: Text('data'),
      onPressed: () => pressed = true,
    )));
    var button = find.byType(RaisedButton);
    expect(button, findsOneWidget);
    expect(find.byType(FlatButton), findsNothing);
    expect(find.text('data'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    await tester.tap(button);
    expect(pressed, true);
  });
}
