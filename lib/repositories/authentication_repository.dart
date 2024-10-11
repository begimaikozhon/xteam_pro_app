import 'package:firebase_auth/firebase_auth.dart'; // Импортируем библиотеку для работы с Firebase Authentication.

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth; // Объект FirebaseAuth для аутентификации.

  // Конструктор, который принимает объект FirebaseAuth.
  AuthenticationRepository(this._firebaseAuth);

  // Метод для входа пользователя с электронной почтой и паролем.
  Future<User?> signIn(String email, String password) async {
    // Выполняем вход с помощью указанных учетных данных.
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user; // Возвращаем объект User, если вход успешен.
  }

  // Метод для выхода пользователя.
  Future<void> signOut() async {
    await _firebaseAuth.signOut(); // Вызываем метод signOut из FirebaseAuth.
  }

  // Метод для регистрации нового пользователя с электронной почтой и паролем.
  Future<User?> register(String email, String password) async {
    // Выполняем регистрацию с помощью указанных учетных данных.
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user; // Возвращаем объект User, если регистрация успешна.
  }
}
