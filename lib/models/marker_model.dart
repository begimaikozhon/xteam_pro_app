class MarkerModel {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  MarkerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  static MarkerModel fromMap(String id, Map<String, dynamic> map) {
    return MarkerModel(
      id: id,
      title: map['title'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
