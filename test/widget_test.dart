import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:royaldelivery/main.dart';

void main() {
  testWidgets('Rider completes a delivery and earnings update', (tester) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Let’s go online'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accept delivery'));
    await tester.pumpAndSettle();
    expect(find.text('City Kitchen'), findsOneWidget);
    await tester.tap(find.text('Confirm pickup →'));
    await tester.pumpAndSettle();
    expect(find.text('Delivery for Tariro'), findsOneWidget);
    await tester.tap(find.text('Complete delivery'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm handover'));
    await tester.pumpAndSettle();
    expect(find.text('\$29.00'), findsWidgets);
    expect(find.text('Accept delivery'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Phone layout and shift booking work', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    expect(find.text('Ready to roll?'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book this shift').first);
    await tester.pumpAndSettle();
    expect(find.text('Cancel booked shift'), findsOneWidget);
    await tester.tap(find.text('Cancel booked shift'));
    await tester.pumpAndSettle();
    expect(find.text('Book this shift'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
