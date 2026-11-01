import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const ink = Color(0xFF20251F);
const lime = Color(0xFFD5F566);
const paper = Color(0xFFF7F8F2);
const muted = Color(0xFF747B70);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Royal Delivery',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: ink, primary: ink, secondary: lime),
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: ink, letterSpacing: -1.3),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ink, letterSpacing: -.7),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
        bodyMedium: TextStyle(fontSize: 14, color: ink),
      ),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
        backgroundColor: ink, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      )),
    ),
    home: const RiderHome(),
  );
}

class RiderHome extends StatefulWidget {
  const RiderHome({super.key});
  @override
  State<RiderHome> createState() => _RiderHomeState();
}

class _RiderHomeState extends State<RiderHome> {
  int tab = 0;
  bool online = false;
  int stage = 0;
  int completed = 0;
  int selectedDay = 0;
  final Set<String> shifts = {};

  void message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  void info(String title, String body) => showModalBottomSheet<void>(
    context: context, showDragHandle: true, backgroundColor: paper,
    builder: (context) => SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(24, 8, 24, 28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 16), Text(body, style: const TextStyle(height: 1.7)), const SizedBox(height: 24), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Got it')),
    ]))),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1180), child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(24, 18, 24, 16), child: Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.pedal_bike, color: lime, size: 27)),
        const SizedBox(width: 11), const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ROYAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2)), Text('DELIVERY • RIDER', style: TextStyle(fontSize: 9, letterSpacing: 2, color: muted, fontWeight: FontWeight.w700))]),
        const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: const Text('DEMO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: muted))),
        const SizedBox(width: 8), IconButton(onPressed: () => info('Rider support', 'For this demo, support is not connected. In the live app, contact dispatch here for order issues, breakdowns, or safety assistance.\n\nAlways stop somewhere safe before using your phone.'), icon: const Icon(Icons.support_agent_outlined)),
      ])),
      Expanded(child: IndexedStack(index: tab, children: [dashboard(), schedule(), earnings(), account()])),
    ])))),
    bottomNavigationBar: NavigationBar(
      selectedIndex: tab, onDestinationSelected: (value) => setState(() => tab = value), backgroundColor: Colors.white, indicatorColor: lime,
      destinations: const [NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Ride'), NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Schedule'), NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Earnings'), NavigationDestination(icon: Icon(Icons.person_outline), label: 'Account')],
    ),
  );

  Widget dashboard() => LayoutBuilder(builder: (context, constraints) {
    final wide = constraints.maxWidth > 760;
    final content = Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Icon(Icons.wb_sunny_outlined, size: 16, color: muted), const SizedBox(width: 7), const Text('YOUR CITY. YOUR PACE.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.7, color: muted)), const Spacer(), Container(width: 7, height: 7, decoration: BoxDecoration(color: online ? const Color(0xFF5B8F28) : muted, shape: BoxShape.circle)), const SizedBox(width: 5), Text(online ? 'Online' : 'Offline', style: const TextStyle(fontSize: 12, color: muted))]),
      const SizedBox(height: 12), Text(stage > 0 ? 'A little ride.\nA big difference.' : 'Ready to roll?', style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 8), const Text('Good routes. Happy customers. All you.', style: TextStyle(color: muted, height: 1.5)),
      const SizedBox(height: 24), Row(children: [Expanded(child: stat('TODAY’S EARNINGS', '\$${(24.50 + completed * 4.50).toStringAsFixed(2)}', Icons.trending_up)), const SizedBox(width: 12), Expanded(child: stat('DELIVERIES', '${6 + completed}', Icons.inventory_2_outlined))]),
      const SizedBox(height: 22),
      if (stage == 0) ...[
        Row(children: [Text('Your next adventure', style: Theme.of(context).textTheme.titleMedium), const Spacer(), const Icon(Icons.bolt, color: Color(0xFF84A531), size: 20)]),
        const SizedBox(height: 12),
        panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [tag('BIKE FRIENDLY', lime), const Spacer(), const Text('2.4 km total', style: TextStyle(color: muted, fontSize: 12))]), const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('A fresh delivery awaits', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(online ? 'City Kitchen → Bulawayo Central' : 'Go online to find nearby offers', style: const TextStyle(color: muted, fontSize: 12))])), const Text('\$4.50', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 18), const Row(children: [Icon(Icons.schedule, size: 16, color: muted), SizedBox(width: 5), Text('18–24 min', style: TextStyle(color: muted, fontSize: 12)), SizedBox(width: 16), Icon(Icons.shopping_bag_outlined, size: 16, color: muted), SizedBox(width: 5), Text('Small bag · 2 items', style: TextStyle(color: muted, fontSize: 12))]),
          const SizedBox(height: 20), FilledButton(onPressed: () => setState(() { if (!online) { online = true; } else { stage = 1; } }), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(online ? Icons.arrow_forward : Icons.power_settings_new, size: 18), const SizedBox(width: 9), Text(online ? 'Accept delivery' : 'Let’s go online')])),
        ])),
        const SizedBox(height: 14), Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFFECF0E4), borderRadius: BorderRadius.circular(16)), child: const Row(children: [Icon(Icons.eco_outlined, color: Color(0xFF65853D)), SizedBox(width: 12), Expanded(child: Text('Less traffic. More fresh air.\nEvery bike delivery makes a difference.', style: TextStyle(fontSize: 12, height: 1.6)))])),
      ] else deliveryCard(),
      const SizedBox(height: 18), Row(children: [const Icon(Icons.verified_user_outlined, color: muted, size: 15), const SizedBox(width: 7), const Expanded(child: Text('Helmet on. Lights checked. Ride safe.', style: TextStyle(color: muted, fontSize: 11))), if (online && stage == 0) TextButton(onPressed: () => setState(() => online = false), child: const Text('Go offline'))]),
    ]));
    final map = mapView();
    if (wide) { return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [SizedBox(width: 410, child: SingleChildScrollView(child: content)), Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(0, 8, 24, 24), child: ClipRRect(borderRadius: BorderRadius.circular(28), child: map)))]); }
    return SingleChildScrollView(child: Column(children: [SizedBox(height: 290, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: ClipRRect(borderRadius: BorderRadius.circular(24), child: map))), content]));
  });

  Widget mapView() => Stack(children: [
    Positioned.fill(child: CustomPaint(painter: CityMapPainter(active: stage > 0))),
    Positioned(top: 18, left: 18, child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)), child: const Row(children: [Icon(Icons.location_on_outlined, size: 16), SizedBox(width: 6), Text('Bulawayo, Zimbabwe', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))]))),
    const Positioned(top: 67, left: 22, child: Text('ILLUSTRATED DEMO MAP', style: TextStyle(fontSize: 8, letterSpacing: 1.4, color: muted))),
    Align(alignment: const Alignment(.24, -.38), child: marker(Icons.restaurant, ink, Colors.white)),
    Align(alignment: const Alignment(-.24, .2), child: marker(Icons.pedal_bike, lime, ink)),
    if (stage > 0) Align(alignment: const Alignment(.55, .48), child: marker(Icons.home_outlined, ink, lime)),
    Positioned(bottom: 18, left: 18, right: 18, child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: lime, borderRadius: BorderRadius.circular(12)), child: Icon(stage > 0 ? Icons.route : Icons.local_fire_department_outlined, size: 21)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(stage > 0 ? 'Your delivery route' : 'A good place to start', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(stage > 0 ? 'Short trips. Made for two wheels.' : 'Bulawayo Central · Demo pickup area', style: const TextStyle(fontSize: 10, color: muted))])), IconButton(tooltip: 'Map information', onPressed: () => info('Your riding area', 'This illustrated Bulawayo map is a design preview. Live GPS, bike routing, demand zones, and turn-by-turn navigation still need a map provider and dispatch backend.'), icon: const Icon(Icons.my_location, size: 20))]))),
  ]);

  Widget deliveryCard() => panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [tag(stage == 1 ? '01 / PICKUP' : '02 / DROP-OFF', lime), const Spacer(), const Text('#RD-2048', style: TextStyle(color: muted, fontSize: 12))]),
    const SizedBox(height: 18), Text(stage == 1 ? 'City Kitchen' : 'Delivery for Tariro', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8), Text(stage == 1 ? 'Demo pickup · Fife Street, Bulawayo' : 'Demo drop-off · 9th Avenue, Bulawayo', style: const TextStyle(color: muted, height: 1.5)),
    const SizedBox(height: 18), const Divider(),
    ListTile(contentPadding: EdgeInsets.zero, leading: Icon(stage == 1 ? Icons.shopping_bag_outlined : Icons.door_front_door_outlined), title: Text(stage == 1 ? '2 items · Small insulated bag' : 'Hand it to the customer', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)), subtitle: Text(stage == 1 ? '1 × veggie wrap, 1 × juice\nCollect at the side entrance.' : 'Ring the bell at the green gate.\nConfirm handover before completing.', style: const TextStyle(fontSize: 12, height: 1.7))),
    const SizedBox(height: 10), OutlinedButton.icon(onPressed: () => info('Contact ${stage == 1 ? 'the restaurant' : 'Tariro'}', 'Calling and messaging will be available when live order contacts are connected. This demo does not place calls or send messages.'), icon: const Icon(Icons.chat_bubble_outline, size: 17), label: const Text('Contact')), const SizedBox(height: 14),
    FilledButton(onPressed: () { if (stage == 1) { setState(() => stage = 2); } else { showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('Delivery handed over?'), content: const Text('Confirm that the customer has received both items.'), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Not yet')), FilledButton(style: FilledButton.styleFrom(minimumSize: const Size(0, 44)), onPressed: () { Navigator.pop(dialogContext); setState(() { stage = 0; completed++; }); message('Nicely done! \$4.50 added to your demo earnings.'); }, child: const Text('Confirm handover'))])); } }, child: Text(stage == 1 ? 'Confirm pickup →' : 'Complete delivery')),
  ]));

  Widget schedule() => ListView(padding: const EdgeInsets.all(24), children: [
    eyebrow('MAKE TIME FOR YOUR NEXT RIDE'), const SizedBox(height: 10), Text('Your schedule', style: Theme.of(context).textTheme.headlineLarge), const SizedBox(height: 8), const Text('A little planning. A lot of freedom.', style: TextStyle(color: muted)), const SizedBox(height: 24),
    Row(children: List.generate(7, (i) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => setState(() => selectedDay = i), child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: selectedDay == i ? ink : Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(children: [Text(['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'][i], style: TextStyle(fontSize: 9, color: selectedDay == i ? lime : muted)), const SizedBox(height: 10), Text('${i + 1}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: selectedDay == i ? Colors.white : ink))]))))))),
    const SizedBox(height: 24), Text('November ${selectedDay + 1}, 2026 · Demo shifts', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 16),
    ...['11:00 – 14:00', '17:00 – 20:00'].map((time) { final key = '$selectedDay-$time'; final booked = shifts.contains(key); return Padding(padding: const EdgeInsets.only(bottom: 14), child: panel(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [tag(time.startsWith('11') ? 'LUNCH RUN' : 'DINNER RUN', lime), const Spacer(), const Icon(Icons.pedal_bike)]), const SizedBox(height: 16), Text(time, style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 8), const Text('Bulawayo Central · 3 hours', style: TextStyle(color: muted)), const SizedBox(height: 18), FilledButton(onPressed: () => setState(() { booked ? shifts.remove(key) : shifts.add(key); }), child: Text(booked ? 'Cancel booked shift' : 'Book this shift'))]))); }),
  ]);

  Widget earnings() => ListView(padding: const EdgeInsets.all(24), children: [eyebrow('EVERY PEDAL COUNTS'), const SizedBox(height: 10), Text('Your earnings', style: Theme.of(context).textTheme.headlineLarge), const SizedBox(height: 24), Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(26)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('TODAY · DEMO BALANCE', style: TextStyle(color: lime, fontSize: 11, letterSpacing: 1.5)), const SizedBox(height: 12), Text('\$${(24.50 + completed * 4.50).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.w800, letterSpacing: -2)), const SizedBox(height: 8), Text('${6 + completed} deliveries completed. Keep rolling.', style: const TextStyle(color: Colors.white70))])), const SizedBox(height: 24), Row(children: [Expanded(child: stat('BASE PAY', '\$${(21 + completed * 4.50).toStringAsFixed(2)}', Icons.pedal_bike)), const SizedBox(width: 12), Expanded(child: stat('TIPS', '\$3.50', Icons.favorite_outline))]), const SizedBox(height: 28), Text('Delivery activity', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 12), ...List.generate(completed + 1, (i) => Card(elevation: 0, color: Colors.white, child: ListTile(leading: const CircleAvatar(backgroundColor: lime, child: Icon(Icons.check, color: ink)), title: Text(i < completed ? 'City Kitchen' : 'Earlier demo deliveries'), subtitle: const Text('Completed · Today'), trailing: Text(i < completed ? '+\$4.50' : '+\$24.50', style: const TextStyle(fontWeight: FontWeight.w700))))), const SizedBox(height: 20), const Text('Demo earnings only. Payouts and transaction history require a connected payment service.', style: TextStyle(color: muted, height: 1.6))]);

  Widget account() => ListView(padding: const EdgeInsets.all(24), children: [eyebrow('PART OF THE ROYAL CREW'), const SizedBox(height: 10), Text('Your account', style: Theme.of(context).textTheme.headlineLarge), const SizedBox(height: 24), panel(const Row(children: [CircleAvatar(radius: 29, backgroundColor: lime, child: Icon(Icons.person_outline, size: 32, color: ink)), SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Royal Rider', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), SizedBox(height: 5), Text('Demo rider · Bulawayo', style: TextStyle(color: muted))])])), const SizedBox(height: 20),
    accountRow(Icons.pedal_bike, 'My bicycle', 'City bike · Insulated delivery bag', 'Your bike setup', 'Recommended setup: a well-maintained bicycle, working front and rear lights, a helmet, a lock, and a secured insulated delivery bag.\n\nVehicle registration and equipment editing will be connected to your rider profile.'),
    accountRow(Icons.shield_outlined, 'Ride safely', 'Your wellbeing comes first', 'Before every ride', 'Check your brakes, tyres, lights, and helmet. Secure the delivery bag and keep your load manageable. Stop safely before checking an order or contacting a customer.'),
    accountRow(Icons.tune, 'Delivery preferences', 'Short routes. Lighter loads.', 'Built for bikes', 'This demo shows short-distance deliveries and compact orders suitable for an insulated bike bag. Live distance, load limits, and order preferences need dispatch integration.'),
    accountRow(Icons.help_outline, 'Help & support', 'We’re here for your ride', 'Rider support', 'Live chat and dispatch support are not yet connected. This is a local UI demo.'),
    const SizedBox(height: 24), const Center(child: Text('ROYAL DELIVERY\nMade for the way you move.\nv1.0 · Interactive design preview', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: muted, height: 1.9))),
  ]);
  Widget accountRow(IconData icon, String title, String subtitle, String heading, String body) => ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 8), leading: Icon(icon), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(subtitle, style: const TextStyle(color: muted, fontSize: 12)), trailing: const Icon(Icons.chevron_right), onTap: () => info(heading, body));
  Widget eyebrow(String text) => Text(text, style: const TextStyle(color: muted, fontSize: 10, letterSpacing: 1.7, fontWeight: FontWeight.w700));
  Widget panel(Widget child) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE7EAE0))), child: child);
  Widget tag(String text, Color color) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(7)), child: Text(text, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .6)));
  Widget stat(String label, String value, IconData icon) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE7EAE0))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(label, style: const TextStyle(color: muted, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: .7))), Icon(icon, size: 15, color: muted)]), const SizedBox(height: 10), Text(value, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -.8))]));
  Widget marker(IconData icon, Color bg, Color fg) => Container(width: 47, height: 47, decoration: BoxDecoration(color: bg, border: Border.all(color: Colors.white, width: 3), borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 15, offset: Offset(0, 5))]), child: Icon(icon, color: fg, size: 23));
}

class CityMapPainter extends CustomPainter {
  CityMapPainter({required this.active});
  final bool active;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFE9EDE1));
    canvas.save();
    canvas.scale(size.width / 600, size.height / 700);
    final park = Paint()..color = const Color(0xFFD5E1C7);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(360, 80, 170, 175), const Radius.circular(35)), park);
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(25, 420, 150, 145), const Radius.circular(30)), park);
    final block = Paint()..color = const Color(0xFFE0E4D7);
    for (int x = 0; x < 7; x++) { for (int y = 0; y < 8; y++) { canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x * 95.0 + 12, y * 93.0 + 9, 65, 62), const Radius.circular(5)), block); } }
    final road = Paint()..color = const Color(0xFFFCFCF8)..strokeWidth = 13..style = PaintingStyle.stroke;
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(Offset(-30, i * 93.0 + 80), Offset(650, i * 93.0 + 15), road);
      canvas.drawLine(Offset(i * 95.0 + 85, -20), Offset(i * 95.0 + 35, 750), road);
    }
    final avenue = Path()..moveTo(-40, 610)..cubicTo(190, 450, 330, 340, 640, 160);
    canvas.drawPath(avenue, Paint()..color = const Color(0xFFD0D6C7)..strokeWidth = 29..style = PaintingStyle.stroke);
    canvas.drawPath(avenue, road..strokeWidth = 23);
    canvas.drawCircle(const Offset(360, 250), 95, Paint()..color = const Color(0x25AEC95C));
    if (active) {
      final route = Path()..moveTo(228, 420)..lineTo(242, 305)..lineTo(365, 294)..lineTo(372, 217);
      canvas.drawPath(route, Paint()..color = ink..strokeWidth = 7..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke);
    }
    void label(String text, double x, double y, {double fontSize = 10, Color color = muted}) { final painter = TextPainter(text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w600, letterSpacing: 1.2)), textDirection: TextDirection.ltr)..layout(); painter.paint(canvas, Offset(x, y)); }
    label('CITY CENTRE', 210, 155, fontSize: 17, color: const Color(0xFF849174));
    label('BULAWAYO CENTRAL', 340, 475, fontSize: 14, color: const Color(0xFF849174));
    label('BULAWAYO', 220, 585, fontSize: 21, color: const Color(0xFFABB4A0));
    label('Fife Street', 120, 273, fontSize: 9);
    label('Central Park', 365, 117, fontSize: 9);
    label('9th Avenue', 410, 390, fontSize: 9);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CityMapPainter oldDelegate) => active != oldDelegate.active;
}
