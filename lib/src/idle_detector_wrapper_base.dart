import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idle_detector_wrapper/src/idle_detector_controller.dart';

class IdleDetector extends StatefulWidget {
  final Duration idleTime;
  final Widget child;
  final Function? onIdle;
  final IdleDetectorController? controller;
  final bool autoStart;

  IdleDetector({
    required this.idleTime,
    required this.child,
    this.onIdle,
    this.controller,
    this.autoStart = true,
  });

  @override
  _IdleDetectorState createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      _resetTimer();
    }
    if (widget.controller != null) {
      widget.controller!.setTimerFunctions(_resetTimer, _stopTimer);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _stopTimer() {
    _timer?.cancel();
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        handleUserInteraction();
      },
      onPanDown: (details) {
        handleUserInteraction();
      },
      onHorizontalDragEnd: (details) {
        handleUserInteraction();
      },
      onVerticalDragEnd: (details) {
        handleUserInteraction();
      },
      child: widget.child,
    );
  }
}
