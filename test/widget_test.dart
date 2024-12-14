import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_assistance_app/main.dart';

void main() {
  testWidgets('Smoke test for MyApp widget', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app contains expected elements.
    expect(find.text('Hi, Prapti. Welcome Back!'), findsOneWidget);

    // Check if the "Search" field exists.
    expect(find.byType(TextField), findsWidgets);

    // Verify that bottom navigation bar exists.
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Optional: Check specific navigation items.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
  });
}
