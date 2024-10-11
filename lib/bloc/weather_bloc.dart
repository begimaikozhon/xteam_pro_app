import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/models/weather_model.dart';
import 'package:xteam_pro_app/repositories/weather_repository.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weatherData;

  WeatherLoaded(this.weatherData);
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError(this.message);
}

abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final double lat;
  final double lon;

  FetchWeather(this.lat, this.lon);
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weatherData =
            await weatherRepository.fetchWeather(event.lat, event.lon);
        emit(WeatherLoaded(weatherData)); // Здесь weatherData уже WeatherModel
      } catch (e) {
        emit(WeatherError('Не удалось загрузить данные о погоде: $e'));
      }
    });
  }
}
