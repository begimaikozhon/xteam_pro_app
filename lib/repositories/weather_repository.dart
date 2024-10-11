import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xteam_pro_app/models/weather_model.dart';

class WeatherRepository {
  final String apiKey =
      'ced098463ae46cb45db3c6f0d4d4a086'; // Убедитесь, что этот ключ действителен
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body)); // Изменено
    } else {
      throw Exception('Не удалось загрузить данные о погоде: ${response.body}');
    }
  }
}
