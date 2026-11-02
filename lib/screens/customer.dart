import 'package:flutter/material.dart';
import '../delivery_model.dart';
import '../widgets/workspace.dart';
import '../widgets/ui.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key, required this.store});
  final DeliveryStore store;
  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final form = GlobalKey<FormState>();
  final pickup = TextEditingController();
  final dropoff = TextEditingController();
  final notes = TextEditingController();
  final distance = TextEditingController(text: '3');
  DeliveryService service = DeliveryService.parcel;
  bool inCbd = true;
  @override
  void dispose() {
    for (final controller in [pickup, dropoff, notes, distance]) { controller.dispose(); }
    super.dispose();
  }
  double? get fixedPrice {
    final km = inCbd ? 2.0 : double.tryParse(distance.text);
    if (km == null || !km.isFinite || km <= 0 || km > 10000) return null;
    return DeliveryPricing.total(inCbd: inCbd, distance: km);
  }
  @override
  Widget build(BuildContext context) {
    final order = widget.store.active;
    return MapWorkspace(active: order != null, scrollKey: order?.id ?? 'new-request', child: order == null ? requestForm() : activeOrder(order));
  }

  Widget requestForm() => Form(key: form, autovalidateMode: AutovalidateMode.onUserInteraction, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Row(children: [Badge('BULAWAYO, LET’S GO'), Spacer(), Icon(Icons.pedal_bike, color: grey, size: 20)]),
    const SizedBox(height: 14), const PageTitle('Your errands.\nOur two wheels.', 'Across town, without the runaround.'),
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: red, borderRadius: BorderRadius.circular(22)), child: const Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('SMALL ERRANDS. BIG RELIEF.', style: TextStyle(color: Colors.white70, fontSize: 9, letterSpacing: 1.3, fontWeight: FontWeight.w700)), SizedBox(height: 7), Text('Town deliveries, sorted.', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)), SizedBox(height: 4), Text('Bike-first delivery in Bulawayo CBD', style: TextStyle(color: Colors.white, fontSize: 10))])),
      SizedBox(width: 10), Column(children: [Text('\$2', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: -2)), Text('FIXED CBD RATE', style: TextStyle(color: Colors.white, fontSize: 8, letterSpacing: 1))]),
    ])),
    const SizedBox(height: 22), const Text('What are we delivering?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)), const SizedBox(height: 12),
    ServicePicker(children: DeliveryService.values.map((value) => Semantics(selected: service == value, button: true, child: Material(color: Colors.transparent, child: InkWell(borderRadius: BorderRadius.circular(16), onTap: () => setState(() => service = value), child: AnimatedContainer(duration: motionDuration(context), padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6), decoration: BoxDecoration(color: service == value ? blush : Colors.white, border: Border.all(color: service == value ? red : line), borderRadius: BorderRadius.circular(16)), child: Column(children: [Icon(serviceIcon(value), color: service == value ? red : ink, size: 23), const SizedBox(height: 8), Text(value.label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: service == value ? red : ink))])))))).toList()),

    const SizedBox(height: 20), Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Where to?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), const SizedBox(height: 16),
      TextFormField(onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(), controller: pickup, key: const Key('pickup'), textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Pickup address', hintText: 'Street, building & shop', prefixIcon: Icon(Icons.radio_button_checked, size: 18)), validator: (value) => value == null || value.trim().isEmpty ? 'Enter a pickup address' : null),
      const SizedBox(height: 12), TextFormField(onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(), controller: dropoff, key: const Key('dropoff'), textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Drop-off address', hintText: 'Where should it go?', prefixIcon: Icon(Icons.location_on_outlined, color: red)), validator: (value) { if (value == null || value.trim().isEmpty) return 'Enter a drop-off address'; if (value.trim().toLowerCase() == pickup.text.trim().toLowerCase()) return 'Choose a different drop-off address'; return null; }),
      const SizedBox(height: 12), TextFormField(onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(), controller: notes, maxLines: 2, maxLength: 240, decoration: const InputDecoration(labelText: 'Package & instructions', hintText: 'What is it? Any pickup instructions?'), validator: (value) => value == null || value.trim().isEmpty ? 'Describe your delivery' : null),
      const SizedBox(height: 6), const Row(children: [Icon(Icons.pedal_bike, size: 15, color: grey), SizedBox(width: 7), Expanded(child: Text('Small, securely packed items suitable for a bike.', style: TextStyle(color: grey, fontSize: 10)))]),
    ])),
    const SizedBox(height: 14), Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Your fixed delivery price', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)), const SizedBox(height: 6), const Text('We assign a nearby, available rider automatically.', style: TextStyle(fontSize: 12, color: grey, height: 1.6)), const SizedBox(height: 12),
      SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, title: const Text('Within the CBD service area', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), subtitle: const Text('1st–15th Ave · S. Parirenyatwa–Lobengula', style: TextStyle(fontSize: 10, color: grey)), value: inCbd, onChanged: (value) => setState(() { inCbd = value; })),
      if (!inCbd) ...[const SizedBox(height: 10), TextFormField(onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(), controller: distance, key: const Key('distance'), keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Estimated route distance (km)', helperText: 'Demo estimate · outside CBD: \$0.65/km'), onChanged: (_) => setState(() {}), validator: positiveNumber), const SizedBox(height: 14)],
      Row(children: [const Expanded(child: Text('Delivery total', style: TextStyle(fontWeight: FontWeight.w700))), Text(fixedPrice == null ? '—' : money(fixedPrice!), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800))]),
      const SizedBox(height: 6), Text(inCbd ? 'Fixed CBD rate · \$2.00' : 'Fixed rate · \$0.65/km × estimated distance', style: const TextStyle(color: grey, fontSize: 11)),
      const SizedBox(height: 12), const Row(children: [Icon(Icons.payments_outlined, size: 15, color: grey), SizedBox(width: 8), Text('Cash on delivery', style: TextStyle(color: grey, fontSize: 12))]),
      const SizedBox(height: 18), PrimaryButton('Request delivery', onPressed: () {
        if (!(form.currentState?.validate() ?? false)) return;
        final created = widget.store.request(service: service, pickup: pickup.text, dropoff: dropoff.text, notes: notes.text, inCbd: inCbd, distance: inCbd ? 2 : double.parse(distance.text));
        if (created) { FocusScope.of(context).unfocus(); } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not create the request. Check your delivery details.'))); }
      }),
      const SizedBox(height: 10), const Center(child: Text('Local demo · no real request is sent', style: TextStyle(fontSize: 10, color: grey))),
    ])),
    if (service == DeliveryService.business) ...[const SizedBox(height: 14), TextButton.icon(onPressed: () => showInfo(context, 'Deliveries for your business', 'For restaurants, shops, online sellers and corporate accounts.\n\nThe Royal David flyer advertises daily riders, proof of delivery and weekly reports. Discuss availability and contract rates with the team: 0777 361 420.\n\nThis preview does not submit a contract enquiry.'), icon: const Icon(Icons.business_center_outlined), label: const Text('Need regular contract deliveries?'))],
    const SizedBox(height: 18),
  ]));

  String? positiveNumber(String? value) {
    final number = double.tryParse(value ?? '');
    if (number == null || !number.isFinite || number <= 0 || number > 10000) return 'Enter a number above 0, up to 10,000';
    if (DeliveryPricing.total(inCbd: false, distance: number) <= 0) return 'Enter a distance that produces a billable fee';
    return null;
  }

  Widget activeOrder(Delivery order) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Badge(order.id), const Spacer(), const Badge('DEMO')]), const SizedBox(height: 16),
    PageTitle(order.status == DeliveryStatus.requested ? 'Finding your rider.' : order.status == DeliveryStatus.collected ? 'On its way.' : 'You’re in good hands.', order.status == DeliveryStatus.requested ? 'We’ll assign a rider who is nearby and available.' : order.statusLabel),
    Surface(child: Column(children: [RouteSummary(pickup: order.pickup, dropoff: order.dropoff), const Divider(height: 32), Row(children: [Icon(serviceIcon(order.service), size: 18, color: grey), const SizedBox(width: 8), Expanded(child: Text(order.service.description, style: const TextStyle(fontSize: 12))), Text(money(order.price), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))]), const SizedBox(height: 12), Align(alignment: Alignment.centerLeft, child: Text(order.notes, style: const TextStyle(fontSize: 12, color: grey, height: 1.6)))])),
    const SizedBox(height: 20),
    if (order.status == DeliveryStatus.requested) ...[
      const Surface(child: Column(children: [Icon(Icons.radar, color: red, size: 36), SizedBox(height: 14), Text('Looking for a nearby rider', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), SizedBox(height: 10), Text('Your price is fixed. A rider is assigned automatically when nearby and free.', textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 12, height: 1.6)), SizedBox(height: 12), Text('Demo: switch to Rider mode and go online to simulate availability.', textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 11, height: 1.6))])),
    ] else ...[
      Surface(child: Column(children: [Row(children: [const CircleAvatar(backgroundColor: blush, radius: 25, child: Icon(Icons.pedal_bike, color: red)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(order.rider!.name, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 4), const Text('Bicycle courier · Demo rider', style: TextStyle(fontSize: 11, color: grey))])), const Icon(Icons.verified_outlined, color: red)]), const SizedBox(height: 22),
        Row(children: List.generate(3, (i) => Expanded(child: Column(children: [Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 3), decoration: BoxDecoration(color: i <= (order.status == DeliveryStatus.collected ? 1 : 0) ? red : line, borderRadius: BorderRadius.circular(4))), const SizedBox(height: 9), Text(['Assigned', 'Picked up', 'Delivered'][i], style: const TextStyle(fontSize: 10, color: grey))])))),
        const SizedBox(height: 18), OutlinedButton.icon(onPressed: () => showInfo(context, 'Contact your rider', 'Rider calls and messages are not connected in this preview. Royal David’s advertised contact is 0777 361 420.'), icon: const Icon(Icons.chat_bubble_outline, size: 18), label: const Text('Contact rider')),
      ])), const SizedBox(height: 12), const Text('Switch to Rider mode to simulate pickup and delivery. Both views share this demo order.', style: TextStyle(color: grey, fontSize: 12, height: 1.6)),
    ],
    if (order.status != DeliveryStatus.collected) Center(child: TextButton(onPressed: () async {
      final confirmed = await confirmAction(context, 'Cancel this request?', 'This removes the active demo request from both modes.', 'Cancel request');
      if (confirmed && mounted) widget.store.cancel();
    }, child: const Text('Cancel request', style: TextStyle(color: grey)))),
    const SizedBox(height: 20),
  ]);

}
