import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notifications.initialize(initializationSettings);
  }

  Future<void> scheduleMealNotifications(Menu? menu) async {
    if (menu == null) return;

    // Bildirimleri temizle
    await notifications.cancelAll();

    // Kahvaltı bildirimleri
    await _scheduleNotification(
      id: 1,
      title: 'Kahvaltı Başladı! 🍳',
      body: 'Bugünün kahvaltı menüsü:\n${_getBreakfastMenu(menu)}',
      scheduledTime: _getTodayAt(7, 0), // 07:00
    );

    await _scheduleNotification(
      id: 2,
      title: 'Kahvaltı Bitmek Üzere! ⏰',
      body: 'Kahvaltı menüsü:\n${_getBreakfastMenu(menu)}\n\nHemen yemekhaneye gidin!',
      scheduledTime: _getTodayAt(11, 15), // 11:15
    );

    // Akşam yemeği bildirimleri
    await _scheduleNotification(
      id: 3,
      title: 'Akşam Yemeği Başladı! 🍽️',
      body: 'Bugünün akşam yemeği menüsü:\n${_getDinnerMenu(menu)}',
      scheduledTime: _getTodayAt(16, 0), // 16:00
    );

    await _scheduleNotification(
      id: 4,
      title: 'Akşam Yemeği Bitmek Üzere! ⏰',
      body: 'Akşam yemeği menüsü:\n${_getDinnerMenu(menu)}\n\nHemen yemekhaneye gidin!',
      scheduledTime: _getTodayAt(22, 15), // 22:15
    );
  }

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // Eğer zaman geçmişse, yarın için planla
    DateTime targetTime = scheduledTime;
    if (targetTime.isBefore(DateTime.now())) {
      targetTime = targetTime.add(const Duration(days: 1));
    }

    try {
      await notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(targetTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'meal_notifications',
            'Yemek Bildirimleri',
            channelDescription: 'Günlük yemek menüsü bildirimleri',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // Eğer exact alarm izni yoksa, inexact mode kullan
      if (e.toString().contains('exact_alarms_not_permitted')) {
        print('Exact alarm izni yok, inexact mode kullanılıyor...');
        await notifications.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(targetTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'meal_notifications',
              'Yemek Bildirimleri',
              channelDescription: 'Günlük yemek menüsü bildirimleri',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } else {
        rethrow;
      }
    }
  }

  DateTime _getTodayAt(int hour, int minute) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _getBreakfastMenu(Menu menu) {
    if (menu.breakfast.isEmpty) return 'Menü henüz açıklanmadı';
    
    final breakfastItems = menu.breakfast.take(5).toList();
    if (breakfastItems.length <= 3) {
      return breakfastItems.join(', ');
    } else {
      return '${breakfastItems.take(3).join(', ')} ve ${breakfastItems.length - 3} yemek daha';
    }
  }

  String _getDinnerMenu(Menu menu) {
    if (menu.dinner.isEmpty) return 'Menü henüz açıklanmadı';
    
    final dinnerItems = menu.dinner.take(5).toList();
    if (dinnerItems.length <= 3) {
      return dinnerItems.join(', ');
    } else {
      return '${dinnerItems.take(3).join(', ')} ve ${dinnerItems.length - 3} yemek daha';
    }
  }

  String _getFullMenu(Menu menu) {
    final allItems = menu.items.take(8).map((item) => '${item.name} (${item.gram})').toList();
    if (allItems.isEmpty) return 'Menü henüz açıklanmadı';
    
    if (allItems.length <= 5) {
      return allItems.join('\n• ');
    } else {
      return '${allItems.take(5).join('\n• ')}\n• ve ${allItems.length - 5} yemek daha';
    }
  }

  Future<void> cancelAllNotifications() async {
    await notifications.cancelAll();
  }

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    
    if (!enabled) {
      await cancelAllNotifications();
    }
  }
} 