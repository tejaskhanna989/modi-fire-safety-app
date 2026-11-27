# Modi Fire Safety — Premium Android Customer App

Source code for the Modi International / Modi Fire Safety customer application.

## Development strategy

- **Source code is developed on this VPS.**
- **The Android APK is built on the developer's local machine.** No APK build is attempted here.
- No Flutter, Android SDK, Gradle, or JDK is installed on this VPS.
- No third-party package is added without explicit approval.

## Storage budget

- Soft limit: **1 GB**
- Absolute limit: **2 GB**
- All generated files, dependencies, and temporary artifacts must remain inside this directory.

## Demo vs live

The app ships in `AppMode.demo`. Every integration that is not connected to a real
backend is labelled **SIMULATED** in the UI. See `lib/core/config/app_mode.dart`.

## Planned modules

1. Premium home dashboard
2. Product catalogue and categories
3. Product details and search
4. Shopping cart and demo checkout
5. B2B customer registration
6. Request quotation
7. AI fire safety assistant (simulated rule engine)
8. Servicing and refilling requests
9. Equipment register and QR support
10. Orders and service history
11. Notifications and customer profile

## Phase status

- **Phase 1:** project structure, custom design system, navigation shell,
  Android platform scaffolding, branded home dashboard. No external dependencies.
- **Phase 2:** structured product/category models, illustrative mock
  catalogue, repository boundary, category browsing, search/filtering, product
  details and lightweight demo cart with quantity controls.
- **Phase 3 (current):** B2C/B2B profiles, simulated quotation requests,
  servicing/refilling/inspection requests, equipment register with a clearly
  labelled **DEMO QR – NOT SCANNABLE** visual, and in-memory demo checkout with
  order and service history.
- Phase 4+: remaining modules (each phase requires review before continuing).

## Building locally (on your machine, not here)

```bash
cd <this directory>
flutter pub get
flutter build apk --release
```

The `android/` shell is pre-configured with application id `com.modifire.safety.demo`.
If your local Flutter version expects a different Android Gradle Plugin version,
adjust `android/build.gradle` and `android/gradle/wrapper/gradle-wrapper.properties`
locally — do not change server tooling.

## Important

This project contains **source only**. Cart, orders, payments, notifications, AI
responses and service requests are simulated demo data unless explicitly stated.
