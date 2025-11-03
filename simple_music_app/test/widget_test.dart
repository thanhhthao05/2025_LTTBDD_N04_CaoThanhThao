// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:simple_music_app/main.dart';

void main() {
  testWidgets('App boots to HomeScreen', (
    WidgetTester tester,
  ) async {
    // Build app
    await tester.pumpWidget(const SimpleMusicApp());

    // Expect Home app bar title visible
    expect(find.text('Xin chào'), findsOneWidget);
  });
}
