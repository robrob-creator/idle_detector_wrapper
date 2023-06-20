import 'dart:async';
import 'package:flutter/material.dart';

class IdleDetector extends StatefulWidget {
  final Duration idleTime;
  final Widget child;
  final Function? onIdle;

  IdleDetector({
    required this.idleTime,
    required this.child,
    this.onIdle,
  });

  @override
  _IdleDetectorState createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector> {
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
