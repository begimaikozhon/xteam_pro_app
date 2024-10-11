// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/bloc/authentication_bloc.dart'; // Импортируем блок для аутентификации.
import 'package:xteam_pro_app/pages/home_page.dart'; // Импортируем домашнюю страницу.
import 'package:xteam_pro_app/pages/registration_page.dart'; // Импортируем страницу регистрации.

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(); // Контроллер для ввода email.
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key}); // Контроллер для ввода пароля.

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; // Получаем размеры экрана.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'), // Заголовок страницы.
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05), // Адаптация отступов.
        child: BlocListener<AuthenticationBloc, User?>(
          listener: (context, user) {
            if (user != null) {
              // Если пользователь успешно аутентифицирован, переходим на HomePage.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else {
              // Если произошла ошибка аутентификации, выводим сообщение в консоль.
              print('Ошибка входа');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Выравнивание по центру.
            children: [
              TextField(
                controller: emailController, // Связываем контроллер с текстовым полем.
                decoration: const InputDecoration(labelText: 'Email'), // Метка для поля ввода.
              ),
              TextField(
                controller: passwordController, // Связываем контроллер с текстовым полем.
                decoration: const InputDecoration(labelText: 'Пароль'), // Метка для поля ввода.
                obscureText: true, // Скрываем ввод пароля.
              ),
              SizedBox(height: screenSize.height * 0.02), // Отступ между полями.
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim(); // Получаем текст из поля email.
                  final password = passwordController.text.trim(); // Получаем текст из поля пароля.

                  if (email.isNotEmpty && password.isNotEmpty) {
                    // Если поля не пустые, вызываем метод входа.
                    context.read<AuthenticationBloc>().signIn(email, password);
                  } else {
                    // Если поля пустые, выводим сообщение в консоль.
                    print('Пожалуйста, введите email и пароль.');
                  }
                },
                child: const Text('Войти'), // Текст на кнопке входа.
              ),
              TextButton(
                onPressed: () {
                  // Переход на страницу регистрации.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: const Text('Нет аккаунта? Зарегистрируйтесь.'), // Текст на кнопке перехода.
              ),
            ],
          ),
        ),
      ),
    );
  }
}
