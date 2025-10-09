import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registerUser(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        final newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );

        await _db.collection('users').doc(user.uid).set(newUser.toMap());
      }

      return user;
    } catch (e) {
      print('Error registrando usuario: $e');
      rethrow;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error iniciando sesión: $e');
      rethrow;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
