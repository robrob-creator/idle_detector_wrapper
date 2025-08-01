import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller for managing idle detection state and operations
class IdleDetectorController {
  IdleDetectorState? _state;

  /// Attach the controller to an IdleDetectorState
  void _attach(IdleDetectorState state) {
    _state = state;
  }

  /// Detach the controller from its state
  void _detach() {
    _state = null;
  }

  /// Pause the idle detection timer
  void pause() {
    _state?._pause();
  }

  /// Resume the idle detection timer
  void resume() {
    _state?._resume();
  }

  /// Reset the idle detection timer
  void reset() {
    _state?._reset();
  }

  /// Get the remaining time until idle state
  Duration? get remainingTime {
    return _state?._remainingTime;
  }

  /// Check if currently in idle state
  bool get isIdle {
    return _state?._isIdle ?? false;
  }

  /// Check if the detector is currently paused
  bool get isPaused {
    return _state?._isPaused ?? false;
  }
}

class IdleDetector extends StatefulWidget {
  final Duration idleTime;
  final Widget child;
  final Function? onIdle;
  final Function? onActive;
  final bool detectKeyboardActivity;
  final bool persistTimestamp;
  final String? timestampKey;
  final IdleDetectorController? controller;

  IdleDetector({
    required this.idleTime,
    required this.child,
    this.onIdle,
    this.onActive,
    bool? detectKeyboardActivity,
    this.persistTimestamp =
        false, // Changed to false for backward compatibility
    this.timestampKey,
    this.controller,
  }) : detectKeyboardActivity = detectKeyboardActivity ?? kIsWeb;

  @override
  IdleDetectorState createState() => IdleDetectorState();
}

class IdleDetectorState extends State<IdleDetector> {
  Timer? _timer;
  bool _isIdle = false;
  bool _isPaused = false;
  DateTime? _timerStartTime;
  Duration? _remainingTimeWhenPaused;
  late String _timestampKey;

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    _timestampKey = widget.timestampKey ?? 'idle_detector_last_activity';
    if (widget.persistTimestamp) {
      _initializeTimer();
    } else {
      _resetTimer();
    }
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initializeTimer() async {
    try {
      await _loadLastActivityTimestamp();
    } catch (e) {
      // Fallback to normal behavior if SharedPreferences fails
      _resetTimer();
    }
  }

  Future<void> _loadLastActivityTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastActivity = prefs.getInt(_timestampKey);

      if (lastActivity != null) {
        final lastActivityTime =
            DateTime.fromMillisecondsSinceEpoch(lastActivity);
        final now = DateTime.now();
        final timeSinceLastActivity = now.difference(lastActivityTime);

        if (timeSinceLastActivity >= widget.idleTime) {
          // User was already idle when app started
          _isIdle = true;
          if (widget.onIdle != null) {
            widget.onIdle!();
          }
          _resetTimer();
        } else {
          // Start timer with remaining time
          final remainingTime = widget.idleTime - timeSinceLastActivity;
          _startTimerWithDelay(remainingTime);
        }
      } else {
        // No previous timestamp, start fresh
        _resetTimer();
      }
    } catch (e) {
      // Fallback to normal behavior if SharedPreferences fails
      _resetTimer();
    }
  }

  void _startTimerWithDelay(Duration delay) {
    if (_isPaused) return;

    _timer?.cancel();
    _timerStartTime = DateTime.now();
    _timer = Timer(delay, () {
      if (!_isIdle && !_isPaused) {
        _isIdle = true;
        if (widget.onIdle != null) {
          widget.onIdle!();
        }
      }
    });
  }

  void _resetTimer() {
    if (_isPaused) return;

    _timer?.cancel();
    _timerStartTime = DateTime.now();
    _timer = Timer(widget.idleTime, () {
      if (!_isIdle && !_isPaused) {
        _isIdle = true;
        if (widget.onIdle != null) {
          widget.onIdle!();
        }
      }
    });
  }

  /// Pause the idle detection timer
  void _pause() {
    if (_isPaused || _timer == null) return;

    _isPaused = true;

    // Calculate remaining time
    if (_timerStartTime != null) {
      final elapsed = DateTime.now().difference(_timerStartTime!);
      final totalDuration = _isIdle ? widget.idleTime : widget.idleTime;
      _remainingTimeWhenPaused = totalDuration - elapsed;

      // Ensure remaining time is not negative
      if (_remainingTimeWhenPaused!.isNegative) {
        _remainingTimeWhenPaused = Duration.zero;
      }
    } else {
      _remainingTimeWhenPaused = widget.idleTime;
    }

    _timer?.cancel();
    _timer = null;
  }

  /// Resume the idle detection timer
  void _resume() {
    if (!_isPaused) return;

    _isPaused = false;

    if (_remainingTimeWhenPaused != null) {
      if (_remainingTimeWhenPaused! > Duration.zero) {
        _startTimerWithDelay(_remainingTimeWhenPaused!);
      } else {
        // Time has already elapsed, trigger idle if not already idle
        if (!_isIdle) {
          _isIdle = true;
          if (widget.onIdle != null) {
            widget.onIdle!();
          }
        }
      }
    } else {
      _resetTimer();
    }

    _remainingTimeWhenPaused = null;
  }

  /// Reset the idle detection timer
  void _reset() {
    _timer?.cancel();
    _isIdle = false;
    _isPaused = false;
    _remainingTimeWhenPaused = null;
    _timerStartTime = null;

    if (widget.onActive != null && _isIdle) {
      widget.onActive!();
    }

    _resetTimer();
    _saveTimestamp();
  }

  /// Get the remaining time until idle state
  Duration? get _remainingTime {
    if (_isPaused && _remainingTimeWhenPaused != null) {
      return _remainingTimeWhenPaused;
    }

    if (_timer != null && _timerStartTime != null) {
      final elapsed = DateTime.now().difference(_timerStartTime!);
      final remaining = widget.idleTime - elapsed;
      return remaining.isNegative ? Duration.zero : remaining;
    }

    return null;
  }

  Future<void> _saveTimestamp() async {
    if (widget.persistTimestamp) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            _timestampKey, DateTime.now().millisecondsSinceEpoch);
      } catch (e) {
        // Silently fail if SharedPreferences is not available
      }
    }
  }

  void handleUserInteraction() {
    if (_isPaused) return; // Don't handle interactions when paused

    if (_isIdle) {
      _isIdle = false;
      if (widget.onActive != null) {
        widget.onActive!();
      }
    }
    _resetTimer();
    _saveTimestamp();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        handleUserInteraction();
      },
      onExit: (event) {
        handleUserInteraction();
      },
      onHover: (event) {
        handleUserInteraction();
      },
      child: Listener(
        onPointerMove: (event) {
          handleUserInteraction();
        },
        onPointerDown: (event) {
          handleUserInteraction();
        },
        onPointerSignal: (event) {
          // Handle scroll events for web
          if (event is PointerScrollEvent) {
            handleUserInteraction();
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            handleUserInteraction();
          },
          onPanDown: (details) {
            handleUserInteraction();
          },
          onPanUpdate: (details) {
            handleUserInteraction();
          },
          child: widget.detectKeyboardActivity
              ? Focus(
                  autofocus: true,
                  onKeyEvent: (node, event) {
                    handleUserInteraction();
                    return KeyEventResult.ignored;
                  },
                  child: widget.child,
                )
              : widget.child,
        ),
      ),
    );
  }
}
