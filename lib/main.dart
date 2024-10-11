import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/bloc/authentication_bloc.dart';
import 'package:xteam_pro_app/bloc/map_bloc.dart';
import 'package:xteam_pro_app/pages/splash_screen.dart';
import 'package:xteam_pro_app/bloc/weather_bloc.dart';
import 'package:xteam_pro_app/repositories/weather_repository.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyAGLlcokdjZt4VspHCuxQFT5Li_obagQaE",
  authDomain: "xteam-pro.firebaseapp.com",
  projectId: "xteam-pro",
  storageBucket: "xteam-pro.appspot.com",
  messagingSenderId: "605447539631",
  appId: "1:605447539631:web:03fd9a33bc2756bb027d5a",
  measurementId: "G-9K8LZ5S5CH",
);

void main() async {
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MarkerBloc()),
        BlocProvider(
          create: (context) => AuthenticationBloc(FirebaseAuth.instance),
        ),
        BlocProvider(
          create: (context) => WeatherBloc(
            WeatherRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
