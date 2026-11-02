# Royal David · The Courier Guy

A bike-first Flutter courier app for Bulawayo, with separate customer and rider workspaces sharing local session state.

- **Customer:** select a service, enter addresses and package instructions, review the fixed fee, request delivery and track the automatically assigned rider.
- **Rider:** go online, receive an assigned nearby request, accept it, confirm pickup and complete delivery.
- **Pricing:** fixed $2 within the flyer’s CBD area; fixed $0.65/km outside the CBD, rounded to cents. The store calculates an immutable delivery fee. There is no rider selection, editable fare or negotiation.

## Demo dispatch

Requests wait until the demo rider is online, nearby and free. Dispatch reserves the request for that rider; the rider must accept before pickup. An unaccepted reservation is released if the rider goes offline or leaves the demo radius. Accepted deliveries keep the rider busy through completion. Only one request can be active in this prototype.

Proximity is simulated at 0.8 km with a configurable 3 km demo radius, not live GPS. The map is illustrated; CBD eligibility and outside-CBD distance are manually supplied for the preview. Production requires server-side route distance, pricing, rider availability and assignment.

## Run and check

With a compatible Flutter SDK:

```sh
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
```

## Try the flow

1. Customer: enter pickup, drop-off and package instructions, review the fixed total and tap **Request delivery**.
2. Rider: go online. The nearby free demo rider is automatically assigned. Tap **Accept request**.
3. Confirm pickup, then complete delivery and confirm handover.
4. Customer Activity shows the delivery; Rider Earnings shows the completed fixed fee.

Cancellation is available before pickup. Data resets on app restart. Authentication, live dispatch/GPS, messaging, payments and persistent storage are not connected. Switching modes simulates both sides on one device.

## UI behaviour

Screens initialise on first visit and retain drafts and scroll state. Hidden screens pause their animations. Phone layouts use a single scrolling surface with drag-to-dismiss keyboards; the illustrated map collapses while typing. Service tiles wrap on narrow screens or with larger text. Tabs use short, subtle fades, repeated tab taps do not restart them, and reduced-motion settings disable custom transitions. Desktop activity and account pages use a bounded reading width.

Runtime layout and performance checks require Flutter. The added widget checks cover retained drafts, a 320px phone with larger text, keyboard insets and the delivery workflow.
