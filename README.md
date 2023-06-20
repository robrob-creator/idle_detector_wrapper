# Flutter Idle Detector Package

The Flutter Idle Detector package is a convenient wrapper that allows you to easily detect user idle time within your Flutter applications. With this package, you can set the duration of idle time and specify actions to be performed when the user becomes idle.

## Example Usage

```dart
IdleDetector(
  idleTime: const Duration(minutes: 5),
  onIdle: () {
    // Perform actions when the user becomes idle
  },
  child: Scaffold(
    resizeToAvoidBottomInset: true,
    extendBody: true,
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text('Example'),
    ),
    body: Container(
      child: Text("Example"),
    ),
  ),
),
```

## Getting Started

1. To use this package, follow these steps:

2. Add the following dependency to your project's pubspec.yaml file:

```yaml
dependencies:
  flutter_idle_detector: ^1.0.0
```

3. Run the command flutter pub get to fetch the package.

4. Import the package into your Dart code:

```dart
import 'package:flutter_idle_detector/flutter_idle_detector.dart';
```

5. Start using the IdleDetector widget within your Flutter application as shown in the example usage above.

That's it! You can now easily detect user idle time and perform actions accordingly using the Flutter Idle Detector package.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvement, please open an issue or submit a pull request on the GitHub repository.
