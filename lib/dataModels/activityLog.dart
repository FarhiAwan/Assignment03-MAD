class ActivityLog {
  final String id;
  final double latitude;
  final double longitude;
  final String imageBase64; // Local path or URL
  final DateTime timestamp;

  ActivityLog({required this.id, required this.latitude, required this.longitude, required this.imageBase64, required this.timestamp});

// Add .toJson() and .fromJson() methods for API integration

  Map<String, dynamic> toJson() => {
    'id': id,
    'latitude': latitude,
    'longitude': longitude,
    'imageBase64': imageBase64,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ActivityLog.fromJson(Map<String, dynamic> json) => ActivityLog(
    id: json['id'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    imageBase64: json['imageBase64'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}