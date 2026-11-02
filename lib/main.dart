import 'package:flutter/material.dart';
import 'delivery_model.dart';
import 'screens/account.dart';
import 'screens/activity.dart';
import 'screens/customer.dart';
import 'screens/rider.dart';
import 'widgets/ui.dart';
import 'widgets/workspace.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Royal David · The Courier Guy', debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true, scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(seedColor: red, primary: red, secondary: ink, surface: Colors.white),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, height: 1.1, fontWeight: FontWeight.w800, color: ink, letterSpacing: -1.4),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ink, letterSpacing: -.7),
        bodyMedium: TextStyle(color: ink, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: canvas, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        labelStyle: const TextStyle(color: grey, fontSize: 14),
        errorMaxLines: 3, helperMaxLines: 3,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: line)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: red)),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: red, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 52), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(foregroundColor: ink, minimumSize: const Size(double.infinity, 46), side: const BorderSide(color: line), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)))),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, backgroundColor: ink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true, backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28)))),
      navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.white, indicatorColor: blush, labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
    ), home: const DeliveryApp(),
  );
}

class DeliveryApp extends StatefulWidget {
  const DeliveryApp({super.key});
  @override
  State<DeliveryApp> createState() => _DeliveryAppState();
}

class _DeliveryAppState extends State<DeliveryApp> with SingleTickerProviderStateMixin {
  final store = DeliveryStore();
  late final transition = AnimationController(vsync: this, duration: const Duration(milliseconds: 200))..value = 1;
  late final fade = CurvedAnimation(parent: transition, curve: Curves.easeOut);
  late final pageOpacity = Tween<double>(begin: .88, end: 1).animate(fade);
  bool rider = false;
  int tab = 0;
  final visited = <int>{0};
  void selectTab(int value) {
    if (tab == value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() { tab = value; visited.add((rider ? 3 : 0) + tab); });
    animatePage();
  }
  Widget retainedPage(int index, Widget Function() buildPage) => visited.contains(index)
      ? TickerMode(enabled: index == (rider ? 3 : 0) + tab, child: RepaintBoundary(child: buildPage()))
      : const SizedBox.shrink();
  @override
  void dispose() { fade.dispose(); transition.dispose(); store.dispose(); super.dispose(); }
  void animatePage() {
    if (MediaQuery.disableAnimationsOf(context)) { transition.value = 1; } else { transition.forward(from: 0); }
  }
  void switchMode(bool value) {
    if (rider == value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() { rider = value; tab = 0; visited.add(rider ? 3 : 0); });
    animatePage();
  }
  @override
  Widget build(BuildContext context) => ListenableBuilder(listenable: store, builder: (context, _) => Scaffold(
    body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1280), child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 16, 16, 12), child: Row(children: [const Expanded(child: Align(alignment: Alignment.centerLeft, child: FittedBox(fit: BoxFit.scaleDown, child: Brand()))), const SizedBox(width: 8), const Badge('DEMO'), const SizedBox(width: 4), IconButton(tooltip: 'Help & support', onPressed: () => showInfo(context, 'Here to help', 'Royal David · The Courier Guy\nCall / WhatsApp: 0777 361 420\n\nThis is a local interactive preview. No real orders, calls or payments are sent.'), icon: const Icon(Icons.support_agent_outlined, size: 24))])),
      Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 12), child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFECECEF), borderRadius: BorderRadius.circular(16)), child: Row(children: [modeButton(false, 'Customer', Icons.inventory_2_outlined), modeButton(true, 'Rider', Icons.pedal_bike)]))),
      Expanded(child: FadeTransition(opacity: pageOpacity, child: IndexedStack(index: (rider ? 3 : 0) + tab, children: [
        retainedPage(0, () => CustomerScreen(store: store)),
        retainedPage(1, () => ReadingPane(child: ActivityScreen(store: store, rider: false))),
        retainedPage(2, () => ReadingPane(child: AccountScreen(rider: false, onSwitch: () => switchMode(true)))),
        retainedPage(3, () => RiderScreen(store: store, onCustomer: () => switchMode(false))),
        retainedPage(4, () => ReadingPane(child: ActivityScreen(store: store, rider: true))),
        retainedPage(5, () => ReadingPane(child: AccountScreen(rider: true, onSwitch: () => switchMode(false)))),
      ]))),
    ])))),
    bottomNavigationBar: NavigationBar(height: 70, selectedIndex: tab, onDestinationSelected: selectTab, destinations: [
      NavigationDestination(icon: Icon(rider ? Icons.explore_outlined : Icons.home_outlined), selectedIcon: Icon(rider ? Icons.explore : Icons.home), label: rider ? 'Requests' : 'Send'),
      NavigationDestination(icon: Icon(rider ? Icons.account_balance_wallet_outlined : Icons.receipt_long_outlined), label: rider ? 'Earnings' : 'Activity'),
      const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account'),
    ]),
  ));
  Widget modeButton(bool value, String label, IconData icon) => Expanded(child: Semantics(selected: rider == value, button: true, child: InkWell(key: Key('mode-$label'), borderRadius: BorderRadius.circular(12), onTap: () => switchMode(value), child: AnimatedContainer(duration: motionDuration(context), padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: rider == value ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(12), boxShadow: rider == value ? const [BoxShadow(color: Color(0x08000000), blurRadius: 5, offset: Offset(0, 2))] : []), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 18, color: rider == value ? red : grey), const SizedBox(width: 8), Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: rider == value ? ink : grey))])))));
}
