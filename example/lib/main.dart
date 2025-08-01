import 'dart:async';
import 'package:flutter/material.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idle Detector Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Idle Detector Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _status = 'Active';
  int _idleCount = 0;
  int _activeCount = 0;
  bool _keyboardDetectionEnabled = true;
  bool _mouseActivityDetected = false;
  final _controller = IdleDetectorController();
  Timer? _uiUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Update UI every 100ms to show remaining time
    _uiUpdateTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _uiUpdateTimer?.cancel();
    super.dispose();
  }

  void _onIdle() {
    setState(() {
      _status = 'Idle';
      _idleCount++;
      _mouseActivityDetected = false;
    });
  }

  void _onActive() {
    setState(() {
      _status = 'Active';
      _activeCount++;
      _mouseActivityDetected = true;
      // Reset the indicator after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _mouseActivityDetected = false;
          });
        }
      });
    });
  }

  void _resetCounts() {
    setState(() {
      _status = 'Active';
      _idleCount = 0;
      _activeCount = 0;
      _mouseActivityDetected = false;
    });
    _controller.reset();
  }

  void _togglePause() {
    setState(() {
      if (_controller.isPaused) {
        _controller.resume();
      } else {
        _controller.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      idleTime: const Duration(seconds: 3),
      controller: _controller,
      onIdle: _onIdle,
      onActive: _onActive,
      detectKeyboardActivity: _keyboardDetectionEnabled,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Status: $_status',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: _status == 'Active' ? Colors.green : Colors.red,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Times gone idle: $_idleCount',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'Times became active: $_activeCount',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _mouseActivityDetected
                        ? Colors.green.shade100
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          _mouseActivityDetected ? Colors.green : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mouse,
                        color:
                            _mouseActivityDetected ? Colors.green : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Mouse Activity',
                        style: TextStyle(
                          color: _mouseActivityDetected
                              ? Colors.green.shade700
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Keyboard Detection:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: _keyboardDetectionEnabled,
                          onChanged: (value) {
                            setState(() {
                              _keyboardDetectionEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.orange.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Idle Detection Control (NEW!):',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Status: ${_controller.isPaused ? "PAUSED" : "RUNNING"}',
                                    style: TextStyle(
                                      color: _controller.isPaused
                                          ? Colors.orange
                                          : Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Remaining: ${_controller.remainingTime?.inSeconds ?? "N/A"}s',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: _togglePause,
                              icon: Icon(_controller.isPaused
                                  ? Icons.play_arrow
                                  : Icons.pause),
                              label: Text(
                                  _controller.isPaused ? 'Resume' : 'Pause'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _controller.isPaused
                                    ? Colors.green
                                    : Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '• Pause: Stops idle detection temporarily',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          '• Resume: Continues with remaining time',
                          style: TextStyle(fontSize: 12),
                        ),
                        const Text(
                          '• Reset: Restarts the idle timer (via refresh button)',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test different interactions:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text('• Move your mouse (includes hover, enter, exit)'),
                        Text('• Click anywhere'),
                        Text('• Scroll (especially important for web!)'),
                        Text('• Use keyboard shortcuts (if enabled)'),
                        Text('• Drag elements'),
                        SizedBox(height: 10),
                        Text(
                          'After 3 seconds of inactivity, status will change to "Idle"',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: 50,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Scrollable Item ${index + 1}'),
                        subtitle: const Text('Try scrolling this list!'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _resetCounts,
          tooltip: 'Reset Counters',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
