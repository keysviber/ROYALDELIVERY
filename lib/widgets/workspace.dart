import 'package:flutter/material.dart';
import 'city_map.dart';

/// One scrolling surface on phones; independently scrolling details on desktop.
class MapWorkspace extends StatefulWidget {
  const MapWorkspace({super.key, required this.child, required this.active, required this.scrollKey});
  final Widget child;
  final bool active;
  final String scrollKey;
  @override
  State<MapWorkspace> createState() => _MapWorkspaceState();
}

class _MapWorkspaceState extends State<MapWorkspace> {
  final controller = ScrollController();
  @override
  void didUpdateWidget(covariant MapWorkspace oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollKey != widget.scrollKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !controller.hasClients) return;
        controller.jumpTo(0);
      });
    }
  }
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
    final details = Padding(padding: const EdgeInsets.all(22), child: widget.child);
    if (constraints.maxWidth >= 850) {
      return Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(width: 440, child: SingleChildScrollView(controller: controller, keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, child: details)),
        Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(0, 20, 22, 22), child: CityMap(active: widget.active))),
      ]);
    }
    return SingleChildScrollView(controller: controller, keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, child: Column(children: [
      AnimatedSize(duration: motionDuration(context), curve: Curves.easeOutCubic, alignment: Alignment.topCenter, child: keyboardOpen ? const SizedBox(width: double.infinity) : Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: SizedBox(height: constraints.maxHeight < 500 ? 160 : 210, child: CityMap(active: widget.active)))),
      details,
    ]));
  });
}

class ReadingPane extends StatelessWidget {
  const ReadingPane({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: child));
}

class ServicePicker extends StatelessWidget {
  const ServicePicker({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final columns = constraints.maxWidth < 300 || MediaQuery.textScalerOf(context).scale(14) > 18 ? 2 : 4;
    return Wrap(spacing: 8, runSpacing: 8, children: children.map((child) => SizedBox(width: (constraints.maxWidth - (columns - 1) * 8) / columns, child: child)).toList());
  });
}

Duration motionDuration(BuildContext context) => MediaQuery.disableAnimationsOf(context) ? Duration.zero : const Duration(milliseconds: 180);
