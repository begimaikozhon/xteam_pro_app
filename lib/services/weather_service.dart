import 'dart:convert'; // Импортируем пакет для работы с JSON.
import 'package:http/http.dart' as http; // Импортируем пакет для работы с HTTP-запросами.
import 'package:xteam_pro_app/models/weather_model.dart'; // Импортируем модель данных о погоде.

class WeatherService {
  // Ключ API для доступа к OpenWeatherMap.
  final String apiKey = 'ced098463ae46cb45db3c6f0d4d4a086';

  // Метод для получения данных о погоде по заданным координатам (широта и долгота).
  Future<WeatherModel> fetchWeather(double latitude, double longitude) async {
    // Формируем URL-запрос к API OpenWeatherMap с параметрами координат и ключом API.
    final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
    ));

    // Проверяем статус ответа от сервера.
    if (response.statusCode == 200) {
      // Если ответ успешный (код 200), преобразуем JSON-данные в объект WeatherModel и возвращаем его.
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      // Если ответ не успешный, выбрасываем исключение с сообщением об ошибке.
      throw Exception('Не удалось загрузить данные о погоде');
    }
  }
}
