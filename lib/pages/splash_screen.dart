// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Импортируем Firebase Authentication.
import 'package:firebase_core/firebase_core.dart'; // Импортируем Firebase Core.
import 'home_page.dart'; // Импортируем страницу главного экрана.
import 'login_page.dart'; // Импортируем страницу входа.

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState(); // Создаем состояние для экрана загрузки.
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState(); // Вызываем метод initState родительского класса.
    _initializeFirebase(); // Инициализируем Firebase.
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(); // Инициализация Firebase
      _checkUser(); // Проверяем текущего пользователя после успешной инициализации.
    } catch (e) {
      print('Ошибка инициализации Firebase: $e'); // Логируем ошибку.
      // Здесь можно отобразить сообщение об ошибке или перейти к экрану ошибки.
    }
  }

  void _checkUser() {
    Future.delayed(const Duration(seconds: 3), () { // Задержка на 3 секунды для отображения экрана загрузки.
      User? user = FirebaseAuth.instance.currentUser; // Получаем текущего пользователя из Firebase.
      if (user != null) {
        // Если пользователь уже вошел, переходим на главный экран.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Если пользователь не вошел, переходим на страницу входа.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Центрируем содержимое по вертикали.
          children: [
            // Uncomment the line below and provide a logo image to display a logo.
            // Image.asset('assets/logo.png', height: screenSize.width * 0.3), // Адаптация высоты логотипа
            const SizedBox(height: 20), // Отступ между логотипом и текстом.
            Text(
              'Загрузка...', // Текст загрузки.
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05, // Адаптация размера текста.
                fontWeight: FontWeight.bold, // Жирный шрифт.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
