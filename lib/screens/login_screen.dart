import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/utils/how_notification.dart';

final _emailRegExp = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _obscurePassword = true;
  bool _cargando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
    });

    try {
      final trimmedEmail = _emailController.text.trim();
      final password = _passwordController.text;

      await _auth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      if (mounted) {
        showNotification(
          context,
          message: 'Inicio de sesión exitoso',
          type: NotificationType.success,
        );
      }
    } on FirebaseAuthException catch (e) {
      String messageError;
      switch (e.code) {
        case 'network-request-failed':
          messageError = 'Hubo un error de red, intenta de nuevo más tarde';

        case 'invalid-email':
          messageError = 'El correo electrónico es inválido';

        case 'invalid-credential':
          messageError = 'Las credenciales introducidas no son válidas';

        case 'user-disabled':
          messageError =
              'El usuario ha sido deshabilitado por el administrador';

        case 'too-many-requests':
          messageError = 'Has alcanzado el limite de intentos de inicio de sesión, intenta más tarde';

        default:
          messageError = 'Error de autenticación: ${e.code}';
      }

      if (mounted) {
        showNotification(
          context,
          message: messageError,
          type: NotificationType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        showNotification(
          context,
          message: 'Ocurrió un error inesperado',
          type: NotificationType.error,
        );
      }

      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      label: Text('Correo electrónico'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'El correo electrónico es obligatorio';
                      }
                      if (!_emailRegExp.hasMatch(value.trim())) {
                        return 'El formato del correo no es válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      label: const Text('Contraseña'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña no puede quedar vacía';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener como mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _iniciarSesion,
                      child: _cargando
                          ? SizedBox(
                              height: 20,
                              width: 20,

                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('Iniciar sesión'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
