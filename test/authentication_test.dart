import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xteam_pro_app/repositories/authentication_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('Authentication Tests', () {
    late AuthenticationRepository authRepository;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authRepository = AuthenticationRepository(mockFirebaseAuth);
      mockUserCredential = MockUserCredential();
    });

    test('Successful registration', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) async => mockUserCredential);

      final result =
          await authRepository.register('test@example.com', 'password123');

      expect(result, isNotNull);
    });

    test('Registration with existing email', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
              email: 'test@example.com', password: 'password123'))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      expect(
        () async =>
            await authRepository.register('test@example.com', 'password123'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });
  });
}
