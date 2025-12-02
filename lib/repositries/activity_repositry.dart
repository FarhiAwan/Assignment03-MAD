import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/dataModels/activityLog.dart';
import 'package:http/http.dart' as http; // Import HTTP package

class ActivityRepository {
  static const String key = 'offline_logs';

  // URL for the Mock API (Returns 201 Created on success)
  final String apiUrl = 'https://reqres.in/api/posts';

  // 1. Save Activity (Local + API Sync)
  Future<void> saveActivity(ActivityLog log) async {
    // A. Save Locally first (Guaranteed storage)
    final prefs = await SharedPreferences.getInstance();
    List<String> logs = prefs.getStringList(key) ?? [];
    logs.insert(0, jsonEncode(log.toJson()));
    if (logs.length > 5) {
      logs = logs.sublist(0, 5);
    }
    await prefs.setStringList(key, logs);

    // B. Sync to API (Fire and Forget)
    _syncToApi(log);
  }

  // 2. The actual Network Request
  Future<void> _syncToApi(ActivityLog log) async {
    try {
      print("Attempting to sync with API...");
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(log.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("✅ API Success: Data synced to server.");
        print("Server Response: ${response.body}");
      } else {
        print("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Network Error (Offline mode active): $e");
    }
  }

  // 3. Get Activities (From Local Storage)
  Future<List<ActivityLog>> getActivities() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> logs = prefs.getStringList(key) ?? [];
    return logs.map((e) => ActivityLog.fromJson(jsonDecode(e))).toList();
  }
}