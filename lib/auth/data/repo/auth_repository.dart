import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  });
  Future<Map<String, dynamic>> signInWithGoogle();

  FirebaseAuth get auth;

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerified();
}






