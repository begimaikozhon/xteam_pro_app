// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

// BLoC для аутентификации пользователей
class AuthenticationBloc extends Cubit<User?> {
  final FirebaseAuth
      _firebaseAuth; // Экземпляр FirebaseAuth для работы с аутентификацией

  // Конструктор
  AuthenticationBloc(this._firebaseAuth) : super(null) {
    // Подписываемся на изменения состояния аутентификации
    _firebaseAuth.authStateChanges().listen((user) {
      emit(user); // Обновляем состояние с текущим пользователем
    });
  }

  // Метод для аутентификации пользователя
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password); // Аутентификация
      print('Вход выполнен успешно'); // Успешный вход
    } on FirebaseAuthException catch (e) {
      // Обработка ошибок аутентификации
      if (e.code == 'wrong-password') {
        print('Неверный пароль.');
      } else if (e.code == 'user-not-found') {
        print('Пользователь не найден.');
      } else if (e.code == 'invalid-email') {
        print('Некорректный email.');
      } else {
        print('Ошибка аутентификации: ${e.message}');
      }
    } catch (e) {
      print('Произошла ошибка: $e'); // Обработка других ошибок
    }
  }

  // Метод для выхода из системы
  Future<void> signOut() async {
    await _firebaseAuth.signOut(); // Выход пользователя
  }

  // Метод для регистрации нового пользователя
  Future<void> register(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password); // Регистрация нового пользователя
  }
}
