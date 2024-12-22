class Event {
  final String title;
  final DateTime dateTime;
  final String locationName;
  final double latitude;
  final double longitude;

  Event({
    required this.title,
    required this.dateTime,
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']),
      locationName: json['locationName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
