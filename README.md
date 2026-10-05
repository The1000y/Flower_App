# flower_app

A Flutter e-commerce application.

## Firebase setup

Firebase config files contain project-specific API keys and are **not** committed
to version control. Every credential file has a committed `.example` template
showing the expected shape with placeholder values.

| Ignored file                                          | Tracked template                                                     |
| ----------------------------------------------------- | -------------------------------------------------------------------- |
| `android/app/google-services.json`                     | `android/app/google-services.json.example`                            |
| `lib/config/network/firebase_options.dart`             | `lib/config/network/firebase_options.dart.example`                    |
| `ios/Runner/GoogleService-Info.plist`                 | Provided by the Firebase CLI, no template needed                      |
| `macos/Runner/GoogleService-Info.plist`               | Provided by the Firebase CLI, no template needed                      |

`firebase.json` **is** committed: it only holds project/app identifiers and the
CLI output mapping, contains no secrets, and is required by the Firebase and
FlutterFire CLIs.

### Regenerating the credentials

```bash
# 1. Install the FlutterFire CLI (once).
dart pub global activate flutterfire_cli

# 2. Log in and re-generate the credentials for your Firebase project.
flutterfire configure

# 3. On Android, download the Google Services file from the Firebase console
#    and place it at android/app/google-services.json.
#    Compare it against android/app/google-services.json.example if unsure.
```

Step 2 writes `lib/config/network/firebase_options.dart` and step 3 writes
`android/app/google-services.json`; both stay local to each developer's
checkout.

## Getting Started

This project is a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
