import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modi_fire_safety/app/app.dart';

void main() {
  testWidgets('renders the branded navigation shell', (tester) async {
    await tester.pumpWidget(const ModiFireApp());

    expect(find.text('MODI'), findsOneWidget);
    expect(find.text('FIRE SAFETY'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);
  });
}
