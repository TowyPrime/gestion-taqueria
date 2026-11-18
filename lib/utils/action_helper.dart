import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/utils/how_notification.dart';

class ActionHelper {
  static Future<void> runWithFeedback(
    BuildContext context, {
    required Future<void> Function() action,
    required String successMessage,
    required String errorMessage,
  }) async {
    try {
      await action();

      if (context.mounted) {
        showNotification(
          context,
          message: successMessage,
          type: NotificationType.success,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (context.mounted) {
        showNotification(
          context,
          message: errorMessage,
          type: NotificationType.error,
        );
      }
    }
  }
}
