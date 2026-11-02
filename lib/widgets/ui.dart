import 'package:flutter/material.dart';
import '../delivery_model.dart';

const red = Color(0xFFE82127);
const ink = Color(0xFF19191D);
const canvas = Color(0xFFF6F6F8);
const grey = Color(0xFF64646E);
const blush = Color(0xFFFFEEEE);
const line = Color(0xFFECECF0);

String money(double value) => '\$${value.toStringAsFixed(2)}';
IconData serviceIcon(DeliveryService value) => switch (value) {
  DeliveryService.parcel => Icons.inventory_2_outlined,
  DeliveryService.lunch => Icons.lunch_dining_outlined,
  DeliveryService.documents => Icons.description_outlined,
  DeliveryService.business => Icons.business_center_outlined,
};

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => const Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.pedal_bike, color: red, size: 30), SizedBox(width: 8),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text.rich(TextSpan(children: [TextSpan(text: 'Royal', style: TextStyle(color: ink)), TextSpan(text: 'David', style: TextStyle(color: red))]), style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
      Text('THE COURIER GUY', style: TextStyle(fontSize: 8, letterSpacing: 2.1, fontWeight: FontWeight.w700, color: grey)),
    ]),
  ]);
}

class Surface extends StatelessWidget {
  const Surface({super.key, required this.child, this.color = Colors.white, this.padding = 20});
  final Widget child;
  final Color color;
  final double padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24), border: Border.all(color: color == ink ? ink : line)), child: child,
  );
}

class Badge extends StatelessWidget {
  const Badge(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: dark ? ink : blush, borderRadius: BorderRadius.circular(8)),
    child: Text(text, style: TextStyle(fontSize: 10, color: dark ? Colors.white : red, fontWeight: FontWeight.w700, letterSpacing: .3)),
  );
}

class PageTitle extends StatelessWidget {
  const PageTitle(this.title, this.subtitle, {super.key});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: Theme.of(context).textTheme.headlineLarge), const SizedBox(height: 7), Text(subtitle, style: const TextStyle(color: grey, height: 1.5)),
  ]));
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.text, {super.key, required this.onPressed, this.icon = Icons.arrow_forward});
  final String text;
  final VoidCallback? onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) => FilledButton(onPressed: onPressed, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Flexible(child: Text(text, textAlign: TextAlign.center)), const SizedBox(width: 10), Icon(icon, size: 18)]));
}

class RouteSummary extends StatelessWidget {
  const RouteSummary({super.key, required this.pickup, required this.dropoff});
  final String pickup;
  final String dropoff;
  @override
  Widget build(BuildContext context) => Column(children: [
    _stop(Icons.radio_button_checked, 'PICKUP', pickup, ink),
    const Padding(padding: EdgeInsets.only(left: 38), child: Divider(height: 22)),
    _stop(Icons.location_on, 'DROP-OFF', dropoff, red),
  ]);
  Widget _stop(IconData icon, String label, String text, Color color) => Row(children: [
    Icon(icon, color: color, size: 21), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 10, color: grey, letterSpacing: 1)), const SizedBox(height: 5), Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))])),
  ]);
}

Future<void> showInfo(BuildContext context, String title, String text) => showModalBottomSheet<void>(
  context: context, isScrollControlled: true, showDragHandle: true, backgroundColor: Colors.white,
  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .85, maxWidth: 640),
  builder: (sheetContext) => SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 4, 24, 28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 16), Text(text, style: const TextStyle(height: 1.7, color: grey)), const SizedBox(height: 24), PrimaryButton('Got it', onPressed: () => Navigator.pop(sheetContext), icon: Icons.check),
  ]))),
);

Future<bool> confirmAction(BuildContext context, String title, String text, String action) async => await showDialog<bool>(
  context: context, builder: (dialogContext) => AlertDialog(title: Text(title), content: Text(text), actions: [
    TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Go back')),
    TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(action)),
  ]),
) ?? false;
