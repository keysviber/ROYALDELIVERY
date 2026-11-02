import 'package:flutter_test/flutter_test.dart';
import 'package:royaldelivery/delivery_model.dart';

void main() {
  late DeliveryStore store;
  setUp(() => store = DeliveryStore());
  tearDown(() => store.dispose());
  bool request({String dropoff = '9th Avenue', bool inCbd = true, double distance = 2}) => store.request(
    service: DeliveryService.parcel, pickup: 'Fife Street', dropoff: dropoff,
    notes: 'Small parcel', inCbd: inCbd, distance: distance,
  );

  test('Fixed tariff is calculated by the store, not supplied by a customer', () {
    expect(DeliveryPricing.total(inCbd: true, distance: 8), 2);
    expect(DeliveryPricing.total(inCbd: false, distance: 4), 2.60);
    expect(DeliveryPricing.total(inCbd: false, distance: 3.25), 2.11);
    expect(request(inCbd: false, distance: 4), isTrue);
    expect(store.active!.price, 2.60);
    store.setOnline(true);
    store.acceptRequest();
    store.advance();
    store.advance();
    expect(store.earnings, 2.60);
  });

  test('Reject invalid distances, identical addresses and duplicate requests', () {
    expect(request(distance: double.nan), isFalse);
    expect(request(distance: -1), isFalse);
    expect(request(dropoff: ' fife street '), isFalse);
    expect(request(), isTrue);
    expect(request(), isFalse);
    expect(store.orders, hasLength(1));
  });

  test('Automatically assign only when online and nearby, then require acceptance', () {
    request();
    expect(store.active!.rider, isNull);
    expect(store.acceptRequest(), isFalse);
    store.updateRiderDistance(5);
    store.setOnline(true);
    expect(store.active!.status, DeliveryStatus.requested);
    expect(store.active!.rider, isNull);
    expect(store.acceptRequest(), isFalse);
    store.updateRiderDistance(.8);
    expect(store.active!.status, DeliveryStatus.allocated);
    expect(store.active!.rider!.name, 'Royal Rider');
    store.advance();
    expect(store.active!.status, DeliveryStatus.allocated);
    expect(store.acceptRequest(), isTrue);
    expect(store.active!.status, DeliveryStatus.assigned);
    expect(store.active!.price, 2);
  });

  test('Request auto-assigns immediately if the rider is already available', () {
    store.setOnline(true);
    request();
    expect(store.active!.status, DeliveryStatus.allocated);
    store.setOnline(false);
    expect(store.active!.status, DeliveryStatus.requested);
    expect(store.active!.rider, isNull);
    store.setOnline(true);
    expect(store.active!.status, DeliveryStatus.allocated);
  });

  test('An unaccepted assignment is released if the rider leaves the area', () {
    store.setOnline(true);
    request();
    store.updateRiderDistance(4);
    expect(store.active!.status, DeliveryStatus.requested);
    expect(store.active!.rider, isNull);
  });

  test('Busy rider cannot get a second request; earnings counted once at handover', () {
    request();
    store.setOnline(true);
    store.acceptRequest();
    expect(request(), isFalse);
    expect(store.earnings, 0);
    store.setOnline(false);
    expect(store.online, isTrue);
    store.advance();
    expect(store.active!.status, DeliveryStatus.collected);
    store.cancel();
    expect(store.active!.status, DeliveryStatus.collected);
    store.advance();
    expect(store.active, isNull);
    expect(store.earnings, 2);
    expect(store.completed, 1);
    store.advance();
    expect(store.earnings, 2);
    expect(request(), isTrue);
    expect(store.active!.status, DeliveryStatus.allocated);
  });

  test('Cancellation releases the request without earnings', () {
    store.setOnline(true);
    request();
    store.cancel();
    expect(store.active, isNull);
    expect(store.orders.single.status, DeliveryStatus.cancelled);
    expect(store.earnings, 0);
    expect(request(), isTrue);
  });
}
