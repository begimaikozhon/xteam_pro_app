// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xteam_pro_app/bloc/weather_bloc.dart';
import 'package:xteam_pro_app/models/weather_model.dart';
import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Получаем текущее местоположение при инициализации
  }

  Future<void> _getCurrentLocation() async {
    // Запрашиваем разрешение на доступ к местоположению
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return; // Если разрешение не предоставлено, выходим
      }
    }

    // Получаем текущее местоположение
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // Отправляем событие для получения погоды
    context
        .read<WeatherBloc>()
        .add(FetchWeather(position.latitude, position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/DALL·E 2024-10-04 22.45.01 - A stunning and original landscape of Kyrgyzstan, showcasing the majestic Tian Shan mountains, lush green valleys, and traditional yurts. The scene inc.webp'), // Убедитесь, что путь правильный
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Контент на фоне
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WeatherLoaded) {
                    return _buildWeatherCard(state.weatherData);
                  } else if (state is WeatherError) {
                    return _buildErrorCard(state.message);
                  }
                  return _buildInitialCard();
                },
              ),
            ],
          ),
          // Иконка для открытия страницы Google Maps в правом верхнем углу
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.public,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GoogleMapPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(WeatherModel weatherData) {
    final now = DateTime.now();
    final dateString =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Погода в ${weatherData.location}', // Отображаем название местоположения
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('Температура: ${weatherData.temperature}°C'),
          Text('Влажность: ${weatherData.humidity}%'),
          Text('Скорость ветра: ${weatherData.windSpeed} м/с'),
          const SizedBox(height: 10),
          Text('Дата и время: $dateString'),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: Text(message, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildInitialCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(30),
      ),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      child: const Text('Загрузка данных о погоде...'),
    );
  }
}
