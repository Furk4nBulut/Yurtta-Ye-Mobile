import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yurttaye_mobile/services/notification_service.dart';
import 'package:yurttaye_mobile/models/menu.dart';
import 'package:yurttaye_mobile/models/menu_item.dart';

class NotificationTest {
  static final NotificationService _notificationService = NotificationService();

  static Future<void> testImmediateNotification() async {
    try {
      // Hemen gönderilecek test bildirimi
      await _notificationService.notifications.show(
        999,
        'Test Bildirimi',
        'Bu bir test bildirimidir!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_notifications',
            'Test Bildirimleri',
            channelDescription: 'Test bildirimleri',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
      print('Anlık test bildirimi gönderildi!');
    } catch (e) {
      print('Anlık test bildirimi hatası: $e');
      rethrow;
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
      print('Tüm bildirimler iptal edildi!');
    } catch (e) {
      print('Bildirim iptal hatası: $e');
      rethrow;
    }
  }

  static Future<void> showTestDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bildirim Testi'),
          content: const Text('Anlık test bildirimi göndermek istiyor musunuz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await testImmediateNotification();
                  _showSuccessSnackBar(context, 'Anlık test bildirimi gönderildi!');
                } catch (e) {
                  _showErrorSnackBar(context, 'Test hatası: $e');
                }
              },
              child: const Text('Test Et'),
            ),
          ],
        );
      },
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
} 