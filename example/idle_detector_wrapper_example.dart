// ignore_for_file: use_build_context_synchronously, sdk_version_since

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:idle_detector_wrapper/src/idle_detector_wrapper_base.dart';

class Dashboard extends HookWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: IdleDetector(
        idleTime: const Duration(minutes: 5),
        onIdle: () {},
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBody: true,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Example'),
            ),
            body: Container(
              child: Text("Example"),
            )),
      ),
    );
  }
}
