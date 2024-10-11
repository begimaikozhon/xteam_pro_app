// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/bloc/authentication_bloc.dart'; // Импортируем блок аутентификации.
import 'home_page.dart'; // Импортируем домашнюю страницу.

class RegistrationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(); // Контроллер для ввода email.
  final TextEditingController passwordController = TextEditingController();

  RegistrationPage({super.key}); // Контроллер для ввода пароля.

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // Получаем размер экрана для адаптации интерфейса.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'), // Заголовок страницы.
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05), // Адаптация отступов в зависимости от ширины экрана.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Центрируем элементы по вертикали.
          children: [
            TextField(
              controller: emailController, // Привязываем контроллер для ввода email.
              decoration: const InputDecoration(labelText: 'Email'), // Подсказка для ввода.
            ),
            TextField(
              controller: passwordController, // Привязываем контроллер для ввода пароля.
              decoration: const InputDecoration(labelText: 'Пароль'), // Подсказка для ввода.
              obscureText: true, // Скрываем ввод пароля.
            ),
            SizedBox(height: screenSize.height * 0.02), // Отступ между полями ввода и кнопкой.
            ElevatedButton(
              onPressed: () {
                // Обработка нажатия на кнопку регистрации.
                context.read<AuthenticationBloc>().register(
                  emailController.text,
                  passwordController.text,
                ).then((_) {
                  // После успешной регистрации переходим на домашнюю страницу.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                }).catchError((error) {
                  print('Ошибка регистрации: $error'); // Выводим ошибку в консоль.
                });
              },
              child: const Text('Зарегистрироваться'), // Текст кнопки.
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Возврат на страницу входа.
              },
              child: const Text('Уже есть аккаунт? Войдите.'), // Текст для перехода на страницу входа.
            ),
          ],
        ),
      ),
    );
  }
}
