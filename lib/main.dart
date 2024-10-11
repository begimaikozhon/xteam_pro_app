// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:xteam_pro_app/bloc/authentication_bloc.dart';
import 'package:xteam_pro_app/bloc/map_bloc.dart';
import 'package:xteam_pro_app/pages/splash_screen.dart';
import 'package:xteam_pro_app/bloc/weather_bloc.dart';
import 'package:xteam_pro_app/repositories/weather_repository.dart';

// Конфигурация Firebase
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyAGLlcokdjZt4VspHCuxQFT5Li_obagQaE",
  authDomain: "xteam-pro.firebaseapp.com",
  projectId: "xteam-pro",
  storageBucket: "xteam-pro.appspot.com",
  messagingSenderId: "605447539631",
  appId: "1:605447539631:web:03fd9a33bc2756bb027d5a",
  measurementId: "G-9K8LZ5S5CH",
);

// Мокаем класс FirebaseAuth для тестирования
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}

// Основная функция приложения
void main() async {
  // Инициализируем привязку виджетов Flutter
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Проверяем, инициализирован ли Firebase
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(options: firebaseOptions);
    }
    runApp(const MyApp());
  } catch (e) {
    // Обработка ошибок и отображение сообщения
    print('Ошибка инициализации Firebase: $e');
    runApp(const MyApp()); // Запускаем приложение даже в случае ошибки
  }
}

// Основной виджет приложения
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Провайдер для работы с метками на карте
        BlocProvider(create: (context) => MarkerBloc()),
        // Провайдер для аутентификации
        BlocProvider(
          create: (context) => AuthenticationBloc(FirebaseAuth.instance),
        ),
        // Провайдер для работы с погодой
        BlocProvider(
          create: (context) => WeatherBloc(
            WeatherRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Отключаем баннер в режиме отладки
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Настройка цветовой схемы
          useMaterial3: true, // Используем Material 3
        ),
        home: SplashScreen(), // Начальный экран приложения
      ),
    );
  }
}
