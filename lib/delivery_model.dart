import 'package:flutter/foundation.dart';

enum DeliveryStatus { requested, allocated, assigned, collected, completed, cancelled }

enum DeliveryService {
  parcel('Parcel', 'Parcel pick & drop'),
  lunch('Lunch', 'Lunch delivery'),
  documents('Documents', 'Document delivery'),
  business('Business', 'Corporate delivery');

  const DeliveryService(this.label, this.description);
  final String label;
  final String description;
}

class AssignedRider {
  const AssignedRider(this.name);
  final String name;
}

class DeliveryPricing {
  static double total({required bool inCbd, required double distance}) {
    if (!distance.isFinite || distance <= 0 || distance > 10000) {
      throw ArgumentError.value(distance, 'distance', 'Invalid route distance');
    }
    return inCbd ? 2.0 : (distance * 65).round() / 100;
  }
}

class Delivery {
  Delivery({required this.id, required this.service, required this.pickup,
    required this.dropoff, required this.notes, required this.price,
    required this.inCbd, required this.distance});
  final String id;
  final DeliveryService service;
  final String pickup;
  final String dropoff;
  final String notes;
  final bool inCbd;
  final double distance;
  final double price;
  DeliveryStatus status = DeliveryStatus.requested;
  AssignedRider? rider;

  bool get active => status != DeliveryStatus.completed && status != DeliveryStatus.cancelled;
  String get statusLabel => switch (status) {
    DeliveryStatus.requested => 'Finding a nearby available rider',
    DeliveryStatus.allocated => 'Rider assigned · awaiting acceptance',
    DeliveryStatus.assigned => 'Rider heading to pickup',
    DeliveryStatus.collected => 'On the way to you',
    DeliveryStatus.completed => 'Delivered',
    DeliveryStatus.cancelled => 'Cancelled',
  };
}

/// Local session state. No dispatch, payment, or location network calls.
class DeliveryStore extends ChangeNotifier {
  bool _online = false;
  bool get online => _online;
  double _riderDistanceKm = .8;
  double get riderDistanceKm => _riderDistanceKm;
  bool get riderNearby => _riderDistanceKm <= 3;

  final List<Delivery> _orders = [];
  List<Delivery> get orders => List.unmodifiable(_orders);
  Delivery? get active {
    for (final order in _orders.reversed) {
      if (order.active) return order;
    }
    return null;
  }
  int get completed => _orders.where((o) => o.status == DeliveryStatus.completed).length;
  double get earnings => _orders.where((o) => o.status == DeliveryStatus.completed)
      .fold(0.0, (sum, o) => sum + o.price);

  void setOnline(bool value) {
    final order = active;
    if (!value && (order?.status == DeliveryStatus.assigned ||
        order?.status == DeliveryStatus.collected)) return;
    _online = value;
    _dispatch();
    notifyListeners();
  }

  /// Demo proximity input; live dispatch must supply GPS-derived distance.
  void updateRiderDistance(double distanceKm) {
    if (!distanceKm.isFinite || distanceKm < 0) return;
    _riderDistanceKm = distanceKm;
    _dispatch();
    notifyListeners();
  }

  void _dispatch() {
    final order = active;
    if (order == null) return;
    if (order.status == DeliveryStatus.allocated && (!online || !riderNearby)) {
      order.rider = null;
      order.status = DeliveryStatus.requested;
    }
    if (order.status == DeliveryStatus.requested && online && riderNearby) {
      order.rider = const AssignedRider('Royal Rider');
      order.status = DeliveryStatus.allocated;
    }
  }

  bool request({required DeliveryService service, required String pickup,
    required String dropoff, required String notes,
    required bool inCbd, required double distance}) {
    if (active != null || pickup.trim().isEmpty || dropoff.trim().isEmpty ||
        pickup.trim().toLowerCase() == dropoff.trim().toLowerCase() ||
        notes.trim().isEmpty || !distance.isFinite || distance <= 0 || distance > 10000 ||
        DeliveryPricing.total(inCbd: inCbd, distance: distance) <= 0) return false;
    _orders.add(Delivery(id: 'RD-${2048 + _orders.length}', service: service,
      pickup: pickup.trim(), dropoff: dropoff.trim(), notes: notes.trim(),
      price: DeliveryPricing.total(inCbd: inCbd, distance: distance), inCbd: inCbd, distance: distance));
    _dispatch();
    notifyListeners();
    return true;
  }

  bool acceptRequest() {
    final order = active;
    if (!online || !riderNearby || order == null ||
        order.status != DeliveryStatus.allocated) return false;
    order.status = DeliveryStatus.assigned;
    notifyListeners();
    return true;
  }

  void advance() {
    final order = active;
    if (order == null) return;
    if (order.status == DeliveryStatus.assigned) {
      order.status = DeliveryStatus.collected;
    } else if (order.status == DeliveryStatus.collected) {
      order.status = DeliveryStatus.completed;
    } else {
      return;
    }
    notifyListeners();
  }

  void cancel() {
    final order = active;
    if (order == null || order.status == DeliveryStatus.collected) return;
    order.status = DeliveryStatus.cancelled;
    notifyListeners();
  }
}
