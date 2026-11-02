import 'package:flutter/material.dart';
import '../delivery_model.dart';
import '../widgets/ui.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key, required this.store, required this.rider});
  final DeliveryStore store;
  final bool rider;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: [
    PageTitle(rider ? 'Your earnings' : 'Your deliveries', rider ? 'Every completed delivery adds up.' : 'All your errands, in one place.'),
    if (rider) ...[Surface(color: ink, padding: 28, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('THIS SESSION · DEMO EARNINGS', style: TextStyle(color: Colors.white60, fontSize: 10, letterSpacing: 1.2)), const SizedBox(height: 14), Text(money(store.earnings), style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -2)), const SizedBox(height: 10), Text('${store.completed} completed deliveries · cash', style: const TextStyle(color: Colors.white70, fontSize: 12))])), const SizedBox(height: 24)],
    if (store.orders.isEmpty) const Surface(child: Column(children: [Icon(Icons.receipt_long_outlined, color: red, size: 36), SizedBox(height: 16), Text('A fresh start.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), SizedBox(height: 8), Text('Your delivery activity will appear here after you create a request.', textAlign: TextAlign.center, style: TextStyle(color: grey, height: 1.6))]))
    else ...store.orders.reversed.map((order) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(serviceIcon(order.service), color: red, size: 22), const SizedBox(width: 10), Expanded(child: Text(order.service.description, style: const TextStyle(fontWeight: FontWeight.w700))), Text(money(order.price), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18))]), const SizedBox(height: 16), Text('${order.pickup} → ${order.dropoff}', style: const TextStyle(color: grey, fontSize: 12, height: 1.6)), const SizedBox(height: 14), Wrap(spacing: 10, runSpacing: 8, children: [Badge(order.statusLabel), Text(order.id, style: const TextStyle(color: grey, fontSize: 11))])])))),
    const SizedBox(height: 20), const Text('Local preview only. Requests, assignments and earnings reset when the app restarts. Payments are not processed.', style: TextStyle(color: grey, fontSize: 11, height: 1.7)),
  ]);
}
