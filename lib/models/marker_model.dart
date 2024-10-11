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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkerModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        latitude.hashCode ^
        longitude.hashCode;
  }
}
