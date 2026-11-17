import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  const ErrorScreen({super.key, this.errorMessage = "Ocurrió un error"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(errorMessage)));
  }
}
