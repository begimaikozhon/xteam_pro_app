import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xteam_pro_app/models/weather_model.dart';

class WeatherService {
  final String apiKey = 'ced098463ae46cb45db3c6f0d4d4a086';

  Future<WeatherModel> fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
    ));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Не удалось загрузить данные о погоде');
    }
  }
}
