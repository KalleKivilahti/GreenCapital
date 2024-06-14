import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stepv2/main.dart'; // Adjust the import path based on your project structure

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build your app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: MyApp(), // Replace with your main application widget
    ));

    // Verify that the initial text '0' is found exactly once
    expect(find.text('0'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the text '0' is no longer present, and '1' is found exactly once
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
