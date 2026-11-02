import 'package:flutter/material.dart';
import 'ui.dart';

/// Stylised preview, deliberately labelled as such rather than live geography.
class CityMap extends StatelessWidget {
  const CityMap({super.key, this.active = false});
  final bool active;
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(26), child: Stack(children: [
    Positioned.fill(child: RepaintBoundary(child: CustomPaint(painter: _MapPainter(active)))),
    Positioned(top: 16, left: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.location_on, size: 15, color: red), SizedBox(width: 6), Text('Bulawayo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))]))),
    Positioned(top: 16, right: 16, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.explore_outlined, size: 20))),
    Align(alignment: const Alignment(-.18, .15), child: _pin(Icons.pedal_bike, red)),
    if (active) Align(alignment: const Alignment(.45, -.42), child: _pin(Icons.inventory_2_outlined, ink)),
    const Positioned(bottom: 14, left: 16, child: Text('ILLUSTRATED MAP · DEMO LOCATIONS', style: TextStyle(fontSize: 8, color: grey, letterSpacing: .9))),
  ]));
  Widget _pin(IconData icon, Color color) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(17), border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 5))]), child: Icon(icon, color: Colors.white, size: 23));
}

class _MapPainter extends CustomPainter {
  const _MapPainter(this.active);
  final bool active;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFEDEEEA));
    canvas.save();
    canvas.scale(size.width / 500, size.height / 400);
    final block = Paint()..color = const Color(0xFFE3E5DF);
    for (int x = 0; x < 8; x++) {
      for (int y = 0; y < 7; y++) {
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x * 74.0 - 20, y * 65.0 - 25, 57, 47), const Radius.circular(4)), block);
      }
    }
    canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(277, 34, 116, 92), const Radius.circular(10)), Paint()..color = const Color(0xFFD7E3CD));
    final road = Paint()..color = Colors.white..strokeWidth = 12;
    for (int i = 0; i < 9; i++) {
      canvas.drawLine(Offset(i * 74.0 + 45, 0), Offset(i * 74.0 + 45, 400), road);
      canvas.drawLine(Offset(0, i * 65.0 + 30), Offset(500, i * 65.0 + 30), road);
    }
    if (active) {
      final route = Path()..moveTo(205, 230)..lineTo(193, 230)..lineTo(193, 160)..lineTo(362, 160)..lineTo(362, 116);
      canvas.drawPath(route, Paint()..color = red..strokeWidth = 4..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke);
    }
    void label(String text, double x, double y, {double fontSize = 9}) {
      final painter = TextPainter(text: TextSpan(text: text, style: TextStyle(fontSize: fontSize, color: const Color(0xFF999F93), fontWeight: FontWeight.w600, letterSpacing: .8)), textDirection: TextDirection.ltr)..layout();
      painter.paint(canvas, Offset(x, y));
    }
    label('BULAWAYO CENTRAL', 125, 310, fontSize: 16);
    label('Fife Street', 55, 169);
    label('9th Avenue', 290, 234);
    label('CBD', 325, 82, fontSize: 13);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) => oldDelegate.active != active;
}
