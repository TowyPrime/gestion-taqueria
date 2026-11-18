import 'package:flutter/material.dart';

enum NotificationType { success, error, warning }

void showNotification(
  BuildContext context, {
  required String message,
  required NotificationType type,
}) {
  Color backgroundColor;
  IconData iconData;
  switch (type) {
    case NotificationType.error:
      backgroundColor = Colors.red.withValues(alpha: 0.85);
      iconData = Icons.error_outline;
    case NotificationType.warning:
      backgroundColor = Colors.orange.withValues(alpha: 0.85);
      iconData = Icons.warning_amber_rounded;
    case NotificationType.success:
      backgroundColor = Colors.green.withValues(alpha: 0.85);
      iconData = Icons.check_circle_outline;
  }

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}
