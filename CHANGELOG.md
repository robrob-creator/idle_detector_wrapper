## 1.1.0

### 🚀 New Features

- **onActive Callback**: Added `onActive` parameter to detect when user becomes active after being idle
- **Configurable Keyboard Detection**: Added `detectKeyboardActivity` parameter to control keyboard input detection
- **Platform-Aware Defaults**: Keyboard detection automatically enabled on web, disabled on other platforms
- **Web Scroll Support**: Added comprehensive mouse wheel scroll detection for Flutter Web applications
- **Enhanced Pointer Events**: Improved pointer movement and interaction detection
- **Better Mobile Support**: Enhanced touch gesture detection including pan updates
- **State Tracking**: Internal state management to track idle/active transitions
- **Precise Event Handling**: onActive only triggers when transitioning from idle to active state

### 🐛 Bug Fixes

- **Fixed Web Scroll Issue**: Mouse scrolling in Flutter Web now properly resets idle timer
- **Improved Event Coverage**: Added missing gesture events that weren't being detected

### 🛠️ Technical Improvements

- Added `_isIdle` state tracking to IdleDetectorState
- Enhanced `handleUserInteraction()` method to trigger onActive callback appropriately
- Improved state management to prevent duplicate callback calls
- Added conditional Focus widget wrapping based on keyboard detection setting
- Improved performance on mobile by allowing keyboard detection to be disabled
- Better separation of concerns between platform-specific behaviors
- Added `Listener` widget for low-level pointer events
- Added `Focus` widget for keyboard event detection
- Enhanced `GestureDetector` with additional gesture callbacks
- Improved cross-platform compatibility

### 🧪 Testing & Examples

- Added comprehensive tests for onActive callback functionality
- Updated example app to demonstrate active/idle transitions with counters
- Added tests for multiple idle/active cycles
- Added comprehensive tests for state transition scenarios
- Updated example app with keyboard detection toggle

### 📝 Documentation

- Updated README with onActive callback usage examples
- Enhanced API reference with new parameter documentation
- Added behavioral explanations for state transitions
- Added comprehensive keyboard detection configuration examples
- Updated API reference with new parameter
- Added usage guidelines for different platforms
- Updated README with comprehensive usage examples
- Added platform-specific considerations
- Documented all supported user interactions
- Added troubleshooting section

## 1.0.0

- Initial version.

## 1.1.0

### 🚀 New Features

- **Web Scroll Support**: Added comprehensive mouse wheel scroll detection for Flutter Web applications
- **Enhanced Pointer Events**: Improved pointer movement and interaction detection
- **Keyboard Support**: Added keyboard event detection for complete user activity monitoring
- **Better Mobile Support**: Enhanced touch gesture detection including pan updates

### 🐛 Bug Fixes

- **Fixed Web Scroll Issue**: Mouse scrolling in Flutter Web now properly resets idle timer
- **Improved Event Coverage**: Added missing gesture events that weren't being detected

### 🛠️ Technical Improvements

- Added `Listener` widget for low-level pointer events
- Added `Focus` widget for keyboard event detection
- Enhanced `GestureDetector` with additional gesture callbacks
- Improved cross-platform compatibility

### 📝 Documentation

- Updated README with comprehensive usage examples
- Added platform-specific considerations
- Documented all supported user interactions
- Added troubleshooting section

## 1.0.0

- Initial version.
