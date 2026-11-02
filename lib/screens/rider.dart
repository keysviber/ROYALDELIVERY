import 'package:flutter/material.dart';
import '../delivery_model.dart';
import '../widgets/workspace.dart';
import '../widgets/ui.dart';

class RiderScreen extends StatelessWidget {
  const RiderScreen({super.key, required this.store, required this.onCustomer});
  final DeliveryStore store;
  final VoidCallback onCustomer;
  @override
  Widget build(BuildContext context) {
    final content = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Badge('RIDER WORKSPACE', dark: true), const Spacer(), Text(store.online ? '● Online' : '● Offline', style: TextStyle(color: store.online ? const Color(0xFF218354) : grey, fontSize: 12, fontWeight: FontWeight.w600))]), const SizedBox(height: 16),
      PageTitle(store.active == null ? 'Good day to ride.' : 'A delivery.\nA little possibility.', 'Your city. Your bike. Your next opportunity.'),
      Surface(color: ink, child: Row(children: [const Icon(Icons.pedal_bike, color: Colors.white, size: 28), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(store.online ? 'You’re ready for requests' : 'Ready when you are', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)), const SizedBox(height: 5), const Text('Bulawayo · Bicycle deliveries', style: TextStyle(color: Colors.white60, fontSize: 11))])), Switch.adaptive(value: store.online, onChanged: store.active != null && (store.active!.status == DeliveryStatus.assigned || store.active!.status == DeliveryStatus.collected) ? null : store.setOnline)])),
      const SizedBox(height: 14), Row(children: [Expanded(child: metric('EARNED TODAY', money(store.earnings), Icons.trending_up)), const SizedBox(width: 12), Expanded(child: metric('DELIVERED', '${store.completed}', Icons.inventory_2_outlined))]),
      const SizedBox(height: 24),
      if (store.active != null && (store.active!.status == DeliveryStatus.assigned || store.active!.status == DeliveryStatus.collected)) activeCard(context, store.active!)
      else if (!store.online) Surface(child: Column(children: [const Icon(Icons.power_settings_new, size: 36, color: red), const SizedBox(height: 14), const Text('Take the city at your pace.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 8), const Text('Go online to receive nearby delivery requests assigned to you.', textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 12, height: 1.6)), const SizedBox(height: 20), PrimaryButton('Go online', onPressed: () => store.setOnline(true), icon: Icons.power_settings_new)]))
      else if (store.active?.status == DeliveryStatus.allocated) requestCard(context, store.active!)
      else Surface(child: Column(children: [const Icon(Icons.radar, size: 40, color: red), const SizedBox(height: 14), const Text('Your next delivery starts here.', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)), const SizedBox(height: 10), const Text('No nearby request assigned yet. You receive a request automatically when you are nearby and available. Create one in Customer mode to try the demo.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: grey, height: 1.7)), const SizedBox(height: 18), PrimaryButton('Create a demo request', onPressed: onCustomer)])),
      const SizedBox(height: 18), const Row(children: [Icon(Icons.shield_outlined, size: 16, color: grey), SizedBox(width: 8), Expanded(child: Text('Helmet on. Bag secured. Stop safely to use the app.', style: TextStyle(fontSize: 10, color: grey)))]), const SizedBox(height: 20),
    ]);
    return MapWorkspace(active: store.active != null, scrollKey: '${store.active?.id ?? 'waiting'}-${store.active?.status.name ?? 'idle'}-${store.online}', child: content);
  }

  Widget metric(String label, String value, IconData icon) => Surface(padding: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(label, style: const TextStyle(fontSize: 8, letterSpacing: 1, color: grey, fontWeight: FontWeight.w700))), Icon(icon, size: 17, color: grey)]), const SizedBox(height: 10), Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1))]));

  Widget requestCard(BuildContext context, Delivery order) => Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Badge(order.service.label.toUpperCase()), const Spacer(), Text(order.id, style: const TextStyle(fontSize: 11, color: grey))]), const SizedBox(height: 16),
    Row(children: [const Expanded(child: Text('Fixed delivery fee', style: TextStyle(fontWeight: FontWeight.w600))), Text(money(order.price), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1))]), const SizedBox(height: 18),
    RouteSummary(pickup: order.pickup, dropoff: order.dropoff), const SizedBox(height: 18), Text(order.notes, style: const TextStyle(color: grey, fontSize: 12, height: 1.6)), const SizedBox(height: 12),
    Text(order.inCbd ? 'CBD delivery · Small bike-friendly package' : '${order.distance.toStringAsFixed(1)} km · Customer-estimated distance', style: const TextStyle(color: grey, fontSize: 10)), const SizedBox(height: 20),
    PrimaryButton('Accept request', onPressed: () => store.acceptRequest(), icon: Icons.check), const SizedBox(height: 8),
  ]));

  Widget activeCard(BuildContext context, Delivery order) => Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Badge(order.status == DeliveryStatus.assigned ? '01 / PICKUP' : '02 / DROP-OFF'), const SizedBox(height: 16), Text(order.status == DeliveryStatus.assigned ? 'Let’s collect it.' : 'The final stretch.', style: Theme.of(context).textTheme.headlineSmall), const SizedBox(height: 6), Text('${order.id} · ${order.service.description}', style: const TextStyle(color: grey, fontSize: 12)), const SizedBox(height: 20),
    RouteSummary(pickup: order.pickup, dropoff: order.dropoff), const Divider(height: 32),
    Row(children: [const Icon(Icons.sticky_note_2_outlined, size: 19, color: grey), const SizedBox(width: 12), Expanded(child: Text(order.notes, style: const TextStyle(color: grey, height: 1.6, fontSize: 12)))]), const SizedBox(height: 18),
    Row(children: [const Expanded(child: Text('Cash on delivery', style: TextStyle(fontSize: 12))), Text(money(order.price), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))]), const SizedBox(height: 18),
    OutlinedButton.icon(onPressed: () => showInfo(context, 'Contact customer', 'Customer calls and messages are not connected in this local preview. Royal David support: 0777 361 420.'), icon: const Icon(Icons.chat_bubble_outline, size: 18), label: const Text('Contact customer')), const SizedBox(height: 14),
    PrimaryButton(order.status == DeliveryStatus.assigned ? 'Confirm pickup' : 'Complete delivery', onPressed: () async {
      final pickup = order.status == DeliveryStatus.assigned;
      final confirmed = await confirmAction(context, pickup ? 'Package collected?' : 'Confirm handover', pickup ? 'Confirm you have collected the correct package and secured it on your bike.' : 'Confirm the recipient received the package and the fixed delivery payment was settled.', pickup ? 'Collected' : 'Delivered');
      if (confirmed && context.mounted) {
        store.advance();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pickup ? 'Pickup confirmed. You’re ready for drop-off.' : 'Delivery complete. ${money(order.price)} recorded in your earnings.')));
      }
    }, icon: Icons.check_circle_outline),
  ]));

}
