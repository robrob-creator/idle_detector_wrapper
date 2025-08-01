## 1.2.0

### 🚀 New Features

- **Pause/Resume Control**: Added IdleDetectorController for programmatic control
- **Enhanced Mouse Detection**: Added MouseRegion for comprehensive mouse activity detection
- **Mouse Hover Events**: Now detects mouse enter, exit, and hover events in addition to movement
- **Remaining Time Tracking**: Get real-time remaining time until idle state
- **State Querying**: Check if detector is idle or paused programmatically
- **Timer Reset**: Manually reset idle detection timer and state
- **Timestamp Persistence**: Added optional timestamp persistence across app sessions using SharedPreferences
- **Session Continuity**: When enabled, idle state persists when app is closed and reopened
- **Custom Storage Key**: Added `timestampKey` parameter for custom SharedPreferences keys
- **Backward Compatibility**: Timestamp persistence is disabled by default to maintain backward compatibility
- **Smart Timer Initialization**: When enabled, app starts with correct idle state based on stored timestamp
- **Graceful Fallback**: If SharedPreferences fails, falls back to normal behavior

### 🛠️ Technical Improvements

- **Controller Pattern**: Implemented IdleDetectorController for external state management
- **Pause State Management**: Proper handling of remaining time during pause/resume
- **Enhanced State Tracking**: Added pause state and remaining time calculation
- **MouseRegion Integration**: Layered mouse detection for comprehensive coverage
- **Storage Integration**: Uses SharedPreferences for cross-platform timestamp storage
- **Efficient State Calculation**: Calculates remaining idle time on app startup
- **Error Handling**: Robust error handling for storage operations
- **Memory Management**: Proper cleanup of storage operations

### 📖 Documentation

- **Updated README**: Added comprehensive documentation for timestamp persistence
- **API Reference**: Updated parameter documentation with new options
- **Usage Examples**: Added examples for different persistence scenarios
- **README Formatting**: Fixed markdown formatting issues and code block syntax
- **Table Formatting**: Corrected API reference table formatting
- **Documentation Structure**: Improved overall documentation readability

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
