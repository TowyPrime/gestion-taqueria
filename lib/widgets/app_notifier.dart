import 'package:flutter/material.dart';

class AppNotifier {
  static void show(
    BuildContext context, {
    required String message,
    required String type,
  }) {
    Color backgroundColor;
    IconData iconData;
    final textTheme = Theme.of(context).textTheme;

    switch (type.toLowerCase()) {
      case 'error':
        backgroundColor = Colors.red.shade700;
        iconData = Icons.error_outline_outlined;
      case 'warning':
        backgroundColor = Colors.orange.shade800;
        iconData = Icons.warning_outlined;
      case 'success':
      default:
        backgroundColor = Colors.green.shade700;
        iconData = Icons.check_circle_outline;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(iconData, color: Colors.white),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                message,
                style: textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
