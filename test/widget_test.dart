// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
//
// import 'package:wavex/main.dart';
//
// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());
//
//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);
//
//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();
//
//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }

import 'package:flutter_test/flutter_test.dart';
import 'package:wavex/features/branch_selection/data/models/branch.dart';

void main() {
  test('parses the mobile branch API contract', () {
    final branch = Branch.fromJson({
      'id': 7,
      'name': 'Cairo Central Branch',
      'regionId': 3,
      'address': '100 Main Street',
      'phone': '+201000000000',
      'isActive': true,
    });

    expect(branch.id, 7);
    expect(branch.regionId, 3);
    expect(branch.name, 'Cairo Central Branch');
    expect(branch.isActive, isTrue);
  });
}
