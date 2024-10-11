import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xteam_pro_app/bloc/authentication_bloc.dart';
import 'home_page.dart'; // Импортируйте домашнюю страницу

class RegistrationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05), // Адаптация отступов
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
                context.read<AuthenticationBloc>().register(
                  emailController.text,
                  passwordController.text,
                ).then((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }).catchError((error) {
                  print('Ошибка регистрации: $error');
                });
              },
              child: Text('Зарегистрироваться'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Возврат на страницу входа
              },
              child: Text('Уже есть аккаунт? Войдите.'),
            ),
          ],
        ),
      ),
    );
  }
}
