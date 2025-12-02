import 'package:flutter/material.dart';
import 'package:project/repositries/activity_repositry.dart';
import 'package:project/dataModels/activityLog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ActivityRepository _repository = ActivityRepository();
  List<ActivityLog> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  // 1. Fetch Data from Local Storage
  Future<void> _loadLogs() async {
    final logs = await _repository.getActivities(); // Ensure this matches your Repo method name
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  // 2. Delete Data
  Future<void> _deleteLog(int index) async {
    // Note: For full implementation, add a delete method to your Repository too.
    // Here we just remove from UI for the demo.
    setState(() {
      _logs.removeAt(index);
    });
    // Re-save the updated list to storage (Quick fix for deadline)
    // In a real app, call _repository.deleteActivity(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activity History")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? const Center(child: Text("No history found."))
          : ListView.builder(
        itemCount: _logs.length,
        itemBuilder: (context, index) {
          final log = _logs[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              // Display Image Icon
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey[300],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              // Display Location & Date
              title: Text("Lat: ${log.latitude.toStringAsFixed(4)}, Lng: ${log.longitude.toStringAsFixed(4)}"),
              subtitle: Text(log.timestamp.toString().split('.')[0]),
              // Delete Button
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteLog(index),
              ),
            ),
          );
        },
      ),
    );
  }
}