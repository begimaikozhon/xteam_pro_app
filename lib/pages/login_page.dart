import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/bloc/authentication_bloc.dart';
import 'package:xteam_pro_app/pages/home_page.dart';
import 'package:xteam_pro_app/pages/registration_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Вход'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05), // Адаптация отступов
        child: BlocListener<AuthenticationBloc, User?>(
          listener: (context, user) {
            if (user != null) {
              // Если пользователь аутентифицирован, переходим на HomePage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              // Если ошибка при аутентификации, можно отобразить сообщение
              print('Ошибка входа');
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
              ),
              SizedBox(height: screenSize.height * 0.02), // Адаптация высоты
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  final password = passwordController.text.trim();

                  if (email.isNotEmpty && password.isNotEmpty) {
                    // Входим в приложение
                    context.read<AuthenticationBloc>().signIn(email, password);
                  } else {
                    // Обработка ошибки, если email или пароль пустые
                    print('Пожалуйста, введите email и пароль.');
                  }
                },
                child: Text('Войти'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Text('Нет аккаунта? Зарегистрируйтесь.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
