import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:royaldelivery/main.dart';

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Customer request progresses through rider pickup and handover', (tester) async {
    tester.view.physicalSize = const Size(1200, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byKey(const Key('pickup')), 'Fife Street shop');
    await tester.enterText(find.byKey(const Key('dropoff')), '9th Avenue office');
    await tester.enterText(find.widgetWithText(TextFormField, 'Package & instructions'), 'Small sealed document envelope');
    await tapVisible(tester, find.text('Request delivery'));
    expect(find.text('Finding your rider.'), findsOneWidget);
    expect(find.byKey(const Key('price')), findsNothing);
    expect(find.text('Choose Tawanda M.'), findsNothing);
    await tapVisible(tester, find.byKey(const Key('mode-Rider')));
    await tapVisible(tester, find.text('Go online'));
    await tapVisible(tester, find.text('Accept request'));
    expect(find.text('Offer a different price'), findsNothing);
    await tapVisible(tester, find.byKey(const Key('mode-Customer')));
    expect(find.text('Rider heading to pickup'), findsOneWidget);
    await tapVisible(tester, find.byKey(const Key('mode-Rider')));
    await tapVisible(tester, find.text('Confirm pickup'));
    await tester.tap(find.text('Collected'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Complete delivery'));
    await tester.tap(find.text('Delivered'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Earnings'));
    expect(find.text('1 completed deliveries · cash'), findsOneWidget);
    await tester.tap(find.byKey(const Key('mode-Customer')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();
    expect(find.text('Delivered'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Small phone forms validate and both modes render', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tapVisible(tester, find.text('Request delivery'));
    expect(find.text('Enter a pickup address'), findsOneWidget);
    expect(find.text('Enter a drop-off address'), findsOneWidget);
    await tester.tap(find.byKey(const Key('mode-Rider')));
    await tester.pumpAndSettle();
    expect(find.text('Good day to ride.'), findsOneWidget);
    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Switch to Customer'));
    expect(find.text('Your errands.\nOur two wheels.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Draft survives tabs and modes; repeated selection does not restart transition', (tester) async {
    tester.view.physicalSize = const Size(1200, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byKey(const Key('pickup')), 'Fife Street shop');
    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(find.byKey(const Key('pickup'))).controller!.text, 'Fife Street shop');
    await tester.tap(find.byKey(const Key('mode-Rider')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('mode-Customer')));
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(find.byKey(const Key('pickup'))).controller!.text, 'Fife Street shop');
    await tester.tap(find.text('Send'));
    await tester.pump();
    final pageFade = find.ancestor(of: find.byType(IndexedStack), matching: find.byType(FadeTransition)).first;
    expect(tester.widget<FadeTransition>(pageFade).opacity.value, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Narrow phone with larger text and open keyboard remains usable', (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.byKey(const Key('pickup')));
    await tester.enterText(find.byKey(const Key('pickup')), 'Fife Street shop');
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('ILLUSTRATED MAP · DEMO LOCATIONS'), findsNothing);
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(find.byKey(const Key('pickup'))).controller!.text, 'Fife Street shop');
    await tester.tap(find.byKey(const Key('mode-Rider')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

}
