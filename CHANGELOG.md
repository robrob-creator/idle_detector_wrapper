## 1.2.0

### 🚀 New Features

- **Configurable Keyboard Detection**: Added `detectKeyboardActivity` parameter to control keyboard input detection
- **Platform-Aware Defaults**: Keyboard detection automatically enabled on web, disabled on other platforms
- **Enhanced Flexibility**: Developers can now explicitly enable/disable keyboard detection per use case

### 🛠️ Technical Improvements

- Added conditional Focus widget wrapping based on keyboard detection setting
- Improved performance on mobile by allowing keyboard detection to be disabled
- Better separation of concerns between platform-specific behaviors

### 📝 Documentation

- Added comprehensive keyboard detection configuration examples
- Updated API reference with new parameter
- Added usage guidelines for different platforms

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
