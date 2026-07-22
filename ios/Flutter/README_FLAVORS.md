iOS Flavor setup instructions

These are helper xcconfig templates for wiring iOS build configurations to Flutter flavors.

Steps to set up flavors in Xcode:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the `Runner` project, then the `Runner` target.
3. In the `Info` tab, duplicate the existing build configurations (Debug/Release) to create `Development`, `Staging`, and `Production` configurations. Or create separate Debug/Release under each flavor as needed.
4. In the `Build Settings` tab, for each configuration, set `Based on Configuration File` to point to the matching xcconfig file under `ios/Flutter/` (e.g., `Development.xcconfig`).
5. Update the `PRODUCT_BUNDLE_IDENTIFIER` in those xcconfig files to the appropriate bundle id for each flavor.
6. Add separate `GoogleService-Info.plist` files for each flavor if you use separate Firebase projects, and add them to the matching target/configuration.
7. Create Xcode schemes for each flavor (Product → Scheme → Manage Schemes...), and set the Build Configuration for Run/Archive to the matching flavor configuration.

Running from terminal or VS Code:

- Pass `--flavor` to Flutter and `--dart-define=FLAVOR=...` to set runtime flavor.

Examples:

```bash
# Development (debug)
flutter run --flavor development -t lib/main.dart --dart-define=FLAVOR=development

# Staging (debug)
flutter run --flavor staging -t lib/main.dart --dart-define=FLAVOR=staging

# Production (release)
flutter build ios --flavor production -t lib/main.dart --dart-define=FLAVOR=production
```

Notes:

- Automating Xcode project changes is possible but error-prone; follow the steps in Xcode to ensure correct bundle ids and plist files are assigned to each flavor.
