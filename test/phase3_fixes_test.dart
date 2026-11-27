import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modi_fire_safety/core/state/cart_scope.dart';
import 'package:modi_fire_safety/core/state/cart_state.dart';
import 'package:modi_fire_safety/core/state/demo_data_scope.dart';
import 'package:modi_fire_safety/core/state/demo_data_state.dart';
import 'package:modi_fire_safety/data/models/customer_profile.dart';
import 'package:modi_fire_safety/data/models/quotation_request.dart';
import 'package:modi_fire_safety/data/models/request_enums.dart';
import 'package:modi_fire_safety/features/profile/presentation/b2b_registration_page.dart';
import 'package:modi_fire_safety/features/quotation/presentation/quotation_history_page.dart';
import 'package:modi_fire_safety/features/services/presentation/service_request_page.dart';

Widget withScopes(Widget child, DemoDataState data) {
  return DemoDataScope(
    data: data,
    child: CartScope(
      cart: CartState(),
      child: MaterialApp(home: child),
    ),
  );
}

void main() {
  test('profile edits keep id, type and createdAt', () {
    final state = DemoDataState();
    final original = CustomerProfile(
      id: 'c-edit',
      type: CustomerType.b2b,
      name: 'Old Contact',
      phone: '111',
      email: 'old@example.com',
      companyName: 'Old Co',
      contactPerson: 'Old Contact',
      businessAddress: 'Old Address',
      gstin: 'OLDGST',
      createdAt: DateTime(2026, 1, 1),
    );
    state.saveProfile(original);

    state.saveProfile(CustomerProfile(
      id: original.id,
      type: original.type,
      name: 'New Contact',
      phone: '222',
      email: 'new@example.com',
      companyName: 'New Co',
      contactPerson: 'New Contact',
      businessAddress: 'New Address',
      gstin: 'NEWGST',
      createdAt: original.createdAt,
    ));

    expect(state.profile!.id, 'c-edit');
    expect(state.profile!.type, CustomerType.b2b);
    expect(state.profile!.createdAt, DateTime(2026, 1, 1));
    expect(state.profile!.contactPerson, 'New Contact');
  });

  test('quotation history exposes stored requests newest first', () {
    final state = DemoDataState();
    state.submitQuotation(
      companyName: 'First Co',
      contactPerson: 'First',
      phone: '1',
      email: 'first@example.com',
      notes: '',
      lines: const <QuotationLine>[
        QuotationLine(
          productId: 'p1',
          productName: 'First product',
          quantity: 1,
          unitPrice: 100,
        ),
      ],
    );
    state.submitQuotation(
      companyName: 'Second Co',
      contactPerson: 'Second',
      phone: '2',
      email: 'second@example.com',
      notes: '',
      lines: const <QuotationLine>[
        QuotationLine(
          productId: 'p2',
          productName: 'Second product',
          quantity: 2,
          unitPrice: 200,
        ),
      ],
    );

    expect(state.quotationsNewestFirst.first.id, 'Q-DEMO-0002');
    expect(state.quotationsNewestFirst.last.id, 'Q-DEMO-0001');
  });

  testWidgets('B2B edit form is prefilled and saves updates in place',
      (tester) async {
    final data = DemoDataState();
    final original = CustomerProfile(
      id: 'c-edit',
      type: CustomerType.b2b,
      name: 'Old Contact',
      phone: '111',
      email: 'old@example.com',
      companyName: 'Old Co',
      contactPerson: 'Old Contact',
      businessAddress: 'Old Address',
      gstin: 'OLDGST',
      createdAt: DateTime(2026, 1, 1),
    );
    data.saveProfile(original);

    await tester.pumpWidget(
      withScopes(B2BRegistrationPage(existing: original), data),
    );

    TextFormField field(String label) => tester.widget<TextFormField>(
          find.widgetWithText(TextFormField, label).first,
        );

    expect(field('Company name').controller!.text, 'Old Co');
    expect(field('Contact person').controller!.text, 'Old Contact');
    expect(field('Phone').controller!.text, '111');
    expect(field('Email').controller!.text, 'old@example.com');
    expect(field('Business address').controller!.text, 'Old Address');
    expect(field('GSTIN (optional demo field)').controller!.text, 'OLDGST');

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Contact person'),
      'New Contact',
    );
    await tester.tap(find.text('Save demo profile'));
    await tester.pumpAndSettle();

    expect(data.profile!.contactPerson, 'New Contact');
    expect(data.profile!.companyName, 'Old Co');
    expect(data.profile!.id, 'c-edit');
    expect(data.profile!.type, CustomerType.b2b);
    expect(data.profile!.createdAt, DateTime(2026, 1, 1));
  });

  testWidgets('new B2C registration still works', (tester) async {
    final data = DemoDataState();
    await tester.pumpWidget(
      withScopes(const B2BRegistrationPage(), data),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'New Individual',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone'),
      '9999999999',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'individual@example.com',
    );
    await tester.tap(find.text('Save demo profile'));
    await tester.pumpAndSettle();

    expect(data.profile!.name, 'New Individual');
    expect(data.profile!.type, CustomerType.b2c);
    expect(data.profile!.companyName, isNull);
  });

  testWidgets('service dropdown uses non-nullable String items',
      (tester) async {
    await tester.pumpWidget(
      withScopes(const ServiceRequestPage(), DemoDataState()),
    );

    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.text('Not registered / other'), findsOneWidget);
  });

  testWidgets('quotation history shows reference, lines and status',
      (tester) async {
    final data = DemoDataState();
    final request = data.submitQuotation(
      companyName: 'Demo Co',
      contactPerson: 'Person',
      phone: '8888888888',
      email: 'demo@example.com',
      notes: 'Demo notes',
      lines: const <QuotationLine>[
        QuotationLine(
          productId: 'demo-ext-001',
          productName: 'Demo product',
          quantity: 2,
          unitPrice: 1000,
        ),
      ],
    );

    await tester.pumpWidget(
      withScopes(const QuotationHistoryPage(), data),
    );

    expect(find.text(request.id), findsOneWidget);
    expect(find.text('2 × Demo product'), findsOneWidget);
    expect(find.text('SUBMITTED'), findsOneWidget);
    expect(find.text('Notes: Demo notes'), findsOneWidget);
  });

  testWidgets('editing locks the existing customer type', (tester) async {
    final data = DemoDataState();
    final original = CustomerProfile(
      id: 'c-lock',
      type: CustomerType.b2b,
      name: 'Existing Contact',
      phone: '111',
      email: 'lock@example.com',
      companyName: 'Locked Co',
      contactPerson: 'Existing Contact',
      businessAddress: 'Locked Address',
      gstin: 'LOCKGST',
      createdAt: DateTime(2026, 2, 2),
    );
    data.saveProfile(original);

    await tester.pumpWidget(
      withScopes(B2BRegistrationPage(existing: original), data),
    );

    final b2cChip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Individual (B2C)'),
    );
    final b2bChip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, 'Business (B2B)'),
    );

    expect(b2cChip.onSelected, isNull);
    expect(b2bChip.onSelected, isNull);
    expect(b2cChip.selected, isFalse);
    expect(b2bChip.selected, isTrue);
    expect(
      find.text('Account type is locked while editing an existing profile.'),
      findsOneWidget,
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Individual (B2C)'));
    await tester.pump();
    await tester.tap(find.text('Save demo profile'));
    await tester.pumpAndSettle();

    expect(data.profile!.type, CustomerType.b2b);
    expect(data.profile!.id, 'c-lock');
  });

  testWidgets('new registration can still switch between B2C and B2B',
      (tester) async {
    await tester.pumpWidget(
      withScopes(const B2BRegistrationPage(), DemoDataState()),
    );

    expect(
      tester
          .widget<ChoiceChip>(
            find.widgetWithText(ChoiceChip, 'Individual (B2C)'),
          )
          .onSelected,
      isNotNull,
    );
    expect(
      tester
          .widget<ChoiceChip>(
            find.widgetWithText(ChoiceChip, 'Business (B2B)'),
          )
          .onSelected,
      isNotNull,
    );

    await tester.tap(find.widgetWithText(ChoiceChip, 'Business (B2B)'));
    await tester.pump();

    expect(
      find.widgetWithText(TextFormField, 'Company name'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextFormField, 'GSTIN (optional demo field)'),
      findsOneWidget,
    );
  });
}
