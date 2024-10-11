import 'dart:convert'; // Импортируем библиотеку для работы с JSON.
import 'package:http/http.dart' as http; // Импортируем библиотеку для работы с HTTP-запросами.
import 'package:xteam_pro_app/models/weather_model.dart'; // Импортируем модель данных погоды.

class WeatherRepository {
  // Убедитесь, что этот ключ действителен
  final String apiKey = 'ced098463ae46cb45db3c6f0d4d4a086'; 
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather'; // Базовый URL для API погоды.

  // Метод для получения данных о погоде по координатам.
  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    // Выполняем GET-запрос к API погоды с указанными координатами и API ключом.
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );

    // Проверяем статус ответа.
    if (response.statusCode == 200) {
      // Если статус 200 (ОК), парсим JSON и возвращаем объект WeatherModel.
      return WeatherModel.fromJson(json.decode(response.body)); 
    } else {
      // Если статус не 200, выбрасываем исключение с сообщением об ошибке.
      throw Exception('Не удалось загрузить данные о погоде: ${response.body}');
    }
  }
}
