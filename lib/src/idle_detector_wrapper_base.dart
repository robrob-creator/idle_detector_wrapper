import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class IdleDetector extends StatefulWidget {
  final Duration idleTime;
  final Widget child;
  final Function? onIdle;
  final bool detectKeyboardActivity;

  IdleDetector({
    required this.idleTime,
    required this.child,
    this.onIdle,
    bool? detectKeyboardActivity,
  }) : detectKeyboardActivity = detectKeyboardActivity ?? kIsWeb;

  @override
  IdleDetectorState createState() => IdleDetectorState();
}

class IdleDetectorState extends State<IdleDetector> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    _timer?.cancel();
    _timer = Timer(widget.idleTime, () {
      if (widget.onIdle != null) {
        widget.onIdle!();
      }
    });
  }

  void handleUserInteraction() {
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
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
    );
  }
}
