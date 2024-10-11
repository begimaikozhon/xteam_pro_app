import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/models/weather_model.dart';
import 'package:xteam_pro_app/repositories/weather_repository.dart';

// Абстрактный класс для состояний погоды
abstract class WeatherState {}

// Начальное состояние
class WeatherInitial extends WeatherState {}

// Состояние загрузки данных о погоде
class WeatherLoading extends WeatherState {}

// Состояние, когда данные о погоде успешно загружены
class WeatherLoaded extends WeatherState {
  final WeatherModel weatherData; // Данные о погоде

  WeatherLoaded(this.weatherData);
}

// Состояние ошибки при загрузке данных о погоде
class WeatherError extends WeatherState {
  final String message; // Сообщение об ошибке

  WeatherError(this.message);
}

// Абстрактный класс для событий погоды
abstract class WeatherEvent {}

// Событие для получения данных о погоде
class FetchWeather extends WeatherEvent {
  final double lat; // Широта
  final double lon; // Долгота

  FetchWeather(this.lat, this.lon);
}

// BLoC для управления состоянием погоды
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository; // Репозиторий для получения данных о погоде

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    // Обработка события FetchWeather
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading()); // Устанавливаем состояние загрузки
      try {
        // Получаем данные о погоде из репозитория
        final weatherData = await weatherRepository.fetchWeather(event.lat, event.lon);
        emit(WeatherLoaded(weatherData)); // Устанавливаем состояние с загруженными данными
      } catch (e) {
        emit(WeatherError('Не удалось загрузить данные о погоде: $e')); // Устанавливаем состояние ошибки
      }
    });
  }
}
