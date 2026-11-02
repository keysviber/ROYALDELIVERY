import 'package:flutter/material.dart';
import '../widgets/ui.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key, required this.rider, required this.onSwitch});
  final bool rider;
  final VoidCallback onSwitch;
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(24), children: [
    const PageTitle('Your corner.', 'Anytime. Anywhere. Royal David.'),
    Surface(child: Row(children: [const CircleAvatar(radius: 28, backgroundColor: blush, child: Icon(Icons.person_outline, color: red, size: 30)), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(rider ? 'Royal Rider' : 'Royal Customer', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 5), const Text('Demo profile · Bulawayo', style: TextStyle(color: grey, fontSize: 12))])), const Icon(Icons.verified_outlined, color: red)])), const SizedBox(height: 20),
    tile(context, Icons.swap_horiz, rider ? 'Need something delivered?' : 'Want to deliver with us?', rider ? 'Switch to Customer mode' : 'Switch to Rider mode', onSwitch),
    if (rider) tile(context, Icons.pedal_bike, 'Your bicycle', 'Built for short trips and lighter loads', () => showInfo(context, 'Ready for the road', 'Use a maintained bicycle, a helmet, working lights and a secure delivery bag. Only accept loads that fit safely.\n\nBike and rider verification will be part of live registration.')),
    tile(context, Icons.business_center_outlined, 'Business deliveries', 'For shops, restaurants & corporate accounts', () => showInfo(context, 'Let us handle delivery', 'Royal David offers contract delivery partnerships for food outlets, marketplace sellers, shops, online stores and corporate accounts.\n\nAsk the team about rates, proof of delivery and reporting: 0777 361 420.\n\nThis preview does not send enquiries.')),
    tile(context, Icons.payments_outlined, 'Rates & service area', 'Bulawayo CBD and beyond', () => showInfo(context, 'Simple local pricing', 'The supplied flyer advertises a \$2 town-errand offer within 1st to 15th Avenue, from Samuel Parirenyatwa to Lobengula Street, and \$0.65/km outside the CBD.\n\nThe demo calculates a fixed fee from these rates. Addresses and distances are entered manually; no route distance or eligibility is verified. A nearby available rider is assigned automatically. Customers and riders cannot change the delivery fee.')),
    tile(context, Icons.support_agent, 'Help & contact', '0777 361 420', () => showInfo(context, 'Talk to Royal David', 'Call / WhatsApp: 0777 361 420\nRoyal David Pvt Ltd · Bulawayo\n\nCalling and messaging are not connected in this preview.')),
    const SizedBox(height: 24), PrimaryButton(rider ? 'Switch to Customer' : 'Switch to Rider', onPressed: onSwitch, icon: Icons.swap_horiz), const SizedBox(height: 28), const Center(child: Brand()), const SizedBox(height: 14), const Text('Fast. Reliable. Affordable.\nInteractive preview · v2.0', textAlign: TextAlign.center, style: TextStyle(color: grey, fontSize: 11, height: 1.8)),
  ]);
  Widget tile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback action) => ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 7), leading: Icon(icon, color: ink), title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), subtitle: Text(subtitle, style: const TextStyle(color: grey, fontSize: 11)), trailing: const Icon(Icons.chevron_right, color: grey), onTap: action);
}
