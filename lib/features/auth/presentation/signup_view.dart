// lib/features/auth/presentation/signup_view.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/data/auth_service.dart';
import '../../menu/menu_view.dart';
import 'login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _success = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
      _success = false;
    });

    try {
      final user = await _authService.registerUser(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null && mounted) {
        // Mostrar éxito antes de navegar
        setState(() {
          _success = true;
          _loading = false;
        });

        // Pequeño delay para que el usuario vea el mensaje de éxito
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MenuView()),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Error al crear la cuenta. Intenta nuevamente.';
          _loading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error al crear la cuenta';

      // Mensajes más específicos según el error
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Este correo ya está registrado';
          break;
        case 'weak-password':
          errorMessage = 'La contraseña es muy débil';
          break;
        case 'invalid-email':
          errorMessage = 'El correo electrónico no es válido';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Operación no permitida';
          break;
        default:
          errorMessage = e.message ?? 'Error desconocido';
      }

      setState(() {
        _errorMessage = errorMessage;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inesperado: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Logo y título
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/edukids_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Únete a la aventura de aprender',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'ComicNeue',
                  ),
                ),
                const SizedBox(height: 40),

                // Formulario
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Mensaje de éxito
                        if (_success)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green[100]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '¡Cuenta creada exitosamente!',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'ComicNeue',
                                        ),
                                      ),
                                      Text(
                                        'Bienvenido/a ${_nameController.text}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                          fontFamily: 'ComicNeue',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_success) const SizedBox(height: 20),

                        // Campo de nombre
                        TextFormField(
                          controller: _nameController,
                          enabled: !_loading && !_success,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            labelStyle: TextStyle(
                              color: _loading || _success
                                  ? Colors.grey
                                  : const Color(0xFF764BA2),
                              fontFamily: 'ComicNeue',
                            ),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: _loading || _success
                                  ? Colors.grey
                                  : const Color(0xFF764BA2),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: _loading || _success
                                ? Colors.grey[100]
                                : Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: 16,
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Por favor ingresa tu nombre'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Campo de email
                        TextFormField(
                          controller: _emailController,
                          enabled: !_loading && !_success,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(
                              color: _loading || _success
                                  ? Colors.grey
                                  : const Color(0xFF764BA2),
                              fontFamily: 'ComicNeue',
                            ),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: _loading || _success
                                  ? Colors.grey
                                  : const Color(0xFF764BA2),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: _loading || _success
                                ? Colors.grey[100]
                                : Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: 16,
                          ),
                          validator: (v) => v == null || !v.contains('@')
                              ? 'Por favor ingresa un correo válido'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Campo de contraseña
                        TextFormField(
                          controller: _passwordController,
                          enabled: !_loading && !_success,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                              color: _loading || _success
                                  ? Colors.grey
                                  : const Color(0xFF764BA2),
                              fontFamily: 'ComicNeue',
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: _loading || _success
                                  ? Colors.grey
                                  : const Color(0xFF764BA2),
                            ),
                            suffixIcon: _loading || _success
                                ? null
                                : IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: const Color(0xFF764BA2),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: _loading || _success
                                ? Colors.grey[100]
                                : Colors.grey[50],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: 'ComicNeue',
                            fontSize: 16,
                          ),
                          validator: (v) => v != null && v.length < 6
                              ? 'La contraseña debe tener al menos 6 caracteres'
                              : null,
                        ),
                        const SizedBox(height: 25),

                        // Mensaje de error
                        if (_errorMessage != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red[100]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontFamily: 'ComicNeue',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_errorMessage != null) const SizedBox(height: 20),

                        // Botón de registrarse
                        Container(
                          width: double.infinity,
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: _loading || _success
                                ? null
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                            color: _loading || _success
                                ? Colors.grey[300]
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _loading || _success
                                ? null
                                : [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF764BA2,
                                      ).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                          ),
                          child: ElevatedButton(
                            onPressed: _loading || _success ? null : _register,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: _loading || _success
                                  ? Colors.grey
                                  : Colors.white,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : _success
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Redirigiendo...',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'ComicNeue',
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    'Registrarse',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'ComicNeue',
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Enlace para iniciar sesión
                        if (!_success)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '¿Ya tienes cuenta? ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'ComicNeue',
                                ),
                              ),
                              GestureDetector(
                                onTap: _loading
                                    ? null
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginView(),
                                          ),
                                        );
                                      },
                                child: Text(
                                  'Inicia sesión',
                                  style: TextStyle(
                                    color: _loading
                                        ? Colors.grey
                                        : const Color(0xFF764BA2),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'ComicNeue',
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
