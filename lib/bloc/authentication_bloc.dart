import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationBloc extends Cubit<User?> {
  final FirebaseAuth _firebaseAuth;

  AuthenticationBloc(this._firebaseAuth) : super(null) {
    _firebaseAuth.authStateChanges().listen((user) {
      emit(user);
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('Вход выполнен успешно');
    } on FirebaseAuthException catch (e) {
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
      print('Произошла ошибка: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> register(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}
