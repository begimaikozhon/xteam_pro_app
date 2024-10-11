import 'package:firebase_auth/firebase_auth.dart'; // Импортируем библиотеку для работы с Firebase Authentication.

class FirebaseService {
  // Создаем экземпляр FirebaseAuth для выполнения операций аутентификации.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Метод для получения текущего пользователя.
  User? getCurrentUser() {
    return _firebaseAuth.currentUser; // Возвращаем текущего пользователя, если он есть.
  }

  // Метод для выхода из аккаунта.
  Future<void> signOut() async {
    await _firebaseAuth.signOut(); // Вызываем метод signOut для выхода из аккаунта.
  }
}
