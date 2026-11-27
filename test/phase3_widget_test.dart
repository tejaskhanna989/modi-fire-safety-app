import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modi_fire_safety/app/app.dart';

void main() {
  testWidgets('Phase 3 tabs render without external packages', (tester) async {
    await tester.pumpWidget(const ModiFireApp());
    await tester.pumpAndSettle();

    expect(find.text('MODI'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    expect(find.text('Servicing & refilling'), findsWidgets);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(find.text('Orders & history'), findsWidgets);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('No demo profile yet'), findsOneWidget);
  });
}
