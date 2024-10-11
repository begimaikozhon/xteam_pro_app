class WeatherModel {
  final double temperature;
  final String description;
  final double humidity;
  final double windSpeed;
  final String location;

  WeatherModel({
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.location,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    try {
      return WeatherModel(
        temperature: json['main']['temp'].toDouble(),
        description: json['weather'][0]['description'] ?? 'Нет данных',
        humidity: json['main']['humidity'].toDouble(),
        windSpeed: json['wind']['speed'].toDouble(),
        location: json['name'] ?? 'Неизвестное местоположение',
      );
    } catch (e) {
      throw Exception('Ошибка при парсинге данных о погоде: $e');
    }
  }
}
