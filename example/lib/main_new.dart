import 'package:flutter/material.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _persistTimestamp = false; // Start disabled for demo purposes

  void _onIdle() {
    setState(() {
      _status = 'Idle';
      _idleCount++;
    });
  }

  void _onActive() {
    setState(() {
      _status = 'Active';
      _activeCount++;
    });
  }

  void _togglePersistence() {
    setState(() {
      _persistTimestamp = !_persistTimestamp;
    });
  }

  Future<void> _clearStoredTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('my_custom_idle_key'); // Matches the timestampKey below
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stored timestamp cleared')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IdleDetector(
      idleTime: const Duration(seconds: 3),
      onIdle: _onIdle,
      onActive: _onActive,
      persistTimestamp: _persistTimestamp,
      timestampKey: 'my_custom_idle_key', // Optional custom key
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 40),
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Timestamp Persistence (NEW!):',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Status: ${_persistTimestamp ? "ENABLED" : "DISABLED"}',
                        style: TextStyle(
                          color: _persistTimestamp ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '• When enabled, your last activity is saved',
                        style: TextStyle(fontSize: 14),
                      ),
                      const Text(
                        '• If you close and reopen the app, idle state persists',
                        style: TextStyle(fontSize: 14),
                      ),
                      const Text(
                        '• When disabled (default), works like the original version',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: _togglePersistence,
                            child:
                                Text(_persistTimestamp ? 'Disable' : 'Enable'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _clearStoredTimestamp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text('Clear Stored Data'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      Text('• Move your mouse'),
                      Text('• Click anywhere'),
                      Text('• Scroll (especially important for web!)'),
                      Text('• Use keyboard shortcuts'),
                      Text('• Drag elements'),
                      SizedBox(height: 10),
                      Text(
                        'After 3 seconds of inactivity, status will change to "Idle"',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Try: Enable persistence → Go idle → Close app → Reopen app',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: _onActive,
          tooltip: 'Reset to Active',
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
