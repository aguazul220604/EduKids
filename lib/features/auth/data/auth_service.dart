import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_validator/email_validator.dart';
import '../domain/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Registro con correo y contraseña
  Future<User?> registerUser(String name, String email, String password) async {
    try {
      if (!EmailValidator.validate(email)) {
        throw Exception("Correo inválido");
      }

      if (!_isValidDomain(email)) {
        throw Exception("El dominio del correo no es válido o es temporal.");
      }

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

  /// Inicio de sesión con correo y contraseña
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

  /// 🔥 Inicio de sesión con Google (100% funcional)
  Future<User?> signInWithGoogle() async {
    try {
      // Abre el selector de cuenta Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // Usuario canceló el login

      // Obtiene autenticación de Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crea credencial de Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión con Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      // Guarda en Firestore si no existe
      if (user != null) {
        final userDoc = _db.collection('users').doc(user.uid);
        final doc = await userDoc.get();

        if (!doc.exists) {
          await userDoc.set(
            UserModel(
              uid: user.uid,
              name: user.displayName ?? "Sin nombre",
              email: user.email ?? "",
              createdAt: DateTime.now(),
            ).toMap(),
          );
        }
      }

      return user;
    } catch (e) {
      print('❌ Error en signInWithGoogle: $e');
      rethrow;
    }
  }

  /// Bloquea dominios de correos falsos o temporales
  bool _isValidDomain(String email) {
    final tempDomains = [
      "mailinator.com",
      "tempmail.com",
      "10minutemail.com",
      "guerrillamail.com",
      "yopmail.com",
    ];
    final domain = email.split('@').last.toLowerCase();
    return !tempDomains.contains(domain);
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
