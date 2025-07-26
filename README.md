# Flutter Idle Detector Wrapper

A Flutter package that provides comprehensive idle detection for Flutter applications, including full support for web applications with mouse scroll detection.

## Features

- 🖱️ **Mouse Movement Detection**: Detects mouse movement on all platforms
- 🖲️ **Scroll Detection**: Full support for mouse wheel scrolling (especially important for Flutter Web)
- 👆 **Touch Gestures**: Supports tap, drag, and pan gestures on mobile
- ⌨️ **Keyboard Input**: Detects keyboard interactions
- 🎯 **Cross-Platform**: Works on mobile, web, and desktop platforms
- ⏱️ **Customizable Timeout**: Set your desired idle duration
- 🔄 **Easy Integration**: Simple widget wrapper approach

## Problem Solved

This package specifically addresses the issue where **mouse scrolling in Flutter Web applications was not being detected as user activity**, causing idle callbacks to trigger inappropriately during scrolling.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  idle_detector_wrapper: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = 'Active';

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      idleTime: const Duration(seconds: 30), // 30 seconds idle time
      onIdle: () {
        setState(() {
          status = 'User is idle';
        });
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Idle Detector Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Status: $status'),
              SizedBox(height: 20),
              Text('Try scrolling, clicking, or moving the mouse!'),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Keyboard Detection Configuration

By default, keyboard detection is **enabled on web** and **disabled on other platforms**. You can override this behavior:

```dart
// Explicitly enable keyboard detection (all platforms)
IdleDetector(
  idleTime: const Duration(seconds: 30),
  detectKeyboardActivity: true,
  onIdle: () => print('User is idle'),
  child: MyWidget(),
)

// Explicitly disable keyboard detection (all platforms)
IdleDetector(
  idleTime: const Duration(seconds: 30),
  detectKeyboardActivity: false,
  onIdle: () => print('User is idle'),
  child: MyWidget(),
)

// Use platform default (web: enabled, others: disabled)
IdleDetector(
  idleTime: const Duration(seconds: 30),
  // detectKeyboardActivity parameter omitted - uses platform default
  onIdle: () => print('User is idle'),
  child: MyWidget(),
)
```

**Why disable keyboard detection?**

- Performance: Reduces widget tree complexity on mobile
- Focus conflicts: Prevents issues with text input fields
- Platform consistency: Mobile apps typically don't need keyboard idle detection

### Advanced Usage with State Management

```dart
class IdleDetectorExample extends StatefulWidget {
  @override
  _IdleDetectorExampleState createState() => _IdleDetectorExampleState();
}

class _IdleDetectorExampleState extends State<IdleDetectorExample> {
  bool isIdle = false;
  int idleCount = 0;

  void _handleIdle() {
    setState(() {
      isIdle = true;
      idleCount++;
    });

    // You can trigger any action here:
    // - Show idle warning dialog
    // - Save user data
    // - Pause video/audio
    // - Lock the screen
    // - Log user activity
  }

  void _handleActive() {
    setState(() {
      isIdle = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      idleTime: const Duration(minutes: 2),
      onIdle: _handleIdle,
      child: GestureDetector(
        onTap: _handleActive,
        child: Scaffold(
          backgroundColor: isIdle ? Colors.grey[300] : Colors.white,
          body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  isIdle ? 'IDLE' : 'ACTIVE',
                  style: TextStyle(
                    fontSize: 24,
                    color: isIdle ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Idle count: $idleCount'),
                // Your app content here
                Expanded(
                  child: ListView.builder(
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Item $index'),
                        subtitle: Text('Scroll to test idle detection'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Detected User Activities

The `IdleDetector` responds to all these user interactions:

- **Mouse movements** (desktop/web)
- **Mouse clicks** (all buttons)
- **Mouse wheel scrolling** ⭐ (crucial for web apps)
- **Touch gestures** (tap, drag, pan)
- **Keyboard input** (any key press)
- **Focus changes**

## API Reference

### IdleDetector

| Parameter                | Type        | Required | Description                                                                                       |
| ------------------------ | ----------- | -------- | ------------------------------------------------------------------------------------------------- |
| `idleTime`               | `Duration`  | Yes      | Time duration before considering user idle                                                        |
| `onIdle`                 | `Function?` | No       | Callback function called when user becomes idle                                                   |
| `child`                  | `Widget`    | Yes      | The widget to wrap with idle detection                                                            |
| `detectKeyboardActivity` | `bool?`     | No       | Enable/disable keyboard activity detection. Defaults to `true` on web, `false` on other platforms |

### Methods

- `handleUserInteraction()`: Manually reset the idle timer

## Platform Considerations

### Web Applications

This package specifically addresses Flutter Web limitations:

- ✅ Mouse wheel scrolling is properly detected
- ✅ All pointer events work correctly
- ✅ Keyboard shortcuts are captured

### Mobile Applications

- ✅ Touch gestures (tap, drag, swipe)
- ✅ Scroll detection in lists/views
- ✅ Keyboard input from virtual keyboards

### Desktop Applications

- ✅ Mouse movements and clicks
- ✅ Keyboard input
- ✅ Focus changes

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvement:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Issues and Bugs

If you encounter any issues, especially related to:

- Mouse scroll detection not working
- Platform-specific idle detection problems
- Performance issues

Please open an issue on the [GitHub repository](https://github.com/robrob-creator/idle_detector_wrapper/issues).

## Support the Project

If this package has been helpful for your project, consider supporting its development:

[![Buy Me A Coffee](https://img.shields.io/badge/-buy_me_a%C2%A0coffee-gray?logo=buy-me-a-coffee)](https://coff.ee/robmoonshoz)

Your support helps maintain and improve this package for the Flutter community! ☕️

## License

This project is licensed under the MIT License - see the LICENSE file for details.
