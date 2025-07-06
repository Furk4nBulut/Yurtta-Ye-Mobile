import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/menu.dart';
import '../utils/localization.dart';

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

  Future<void> scheduleDailyMealNotifications(List<Menu> menus) async {
    if (menus.isEmpty) {
      print('Menü listesi boş, bildirim planlanamıyor');
      return;
    }

    // Bildirimleri temizle
    await notifications.cancelAll();

    // Bugünün tarihini al
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Bugünün menülerini filtrele
    var todayMenus = menus.where((menu) {
      final menuDate = '${menu.date.year}-${menu.date.month.toString().padLeft(2, '0')}-${menu.date.day.toString().padLeft(2, '0')}';
      return menuDate == todayString;
    }).toList();

    // Eğer bugünün menüsü yoksa, en yakın tarihteki menüyü kullan
    if (todayMenus.isEmpty) {
      print('Bugünün menüsü bulunamadı, en yakın tarihteki menü aranıyor...');
      
      // Gelecek tarihlerdeki menüleri bul
      final futureMenus = menus.where((menu) => menu.date.isAfter(today)).toList();
      
      if (futureMenus.isNotEmpty) {
        // En yakın tarihteki menüleri al
        final nearestDate = futureMenus.map((m) => m.date).reduce((a, b) => a.isBefore(b) ? a : b);
        todayMenus = futureMenus.where((menu) => 
          menu.date.year == nearestDate.year && 
          menu.date.month == nearestDate.month && 
          menu.date.day == nearestDate.day
        ).toList();
        
        print('En yakın tarihteki menü bulundu: ${nearestDate.toString().split(' ')[0]}');
      } else {
        // Geçmiş tarihlerdeki menüleri kullan (test için)
        final pastMenus = menus.where((menu) => menu.date.isBefore(today)).toList();
        if (pastMenus.isNotEmpty) {
          final latestDate = pastMenus.map((m) => m.date).reduce((a, b) => a.isAfter(b) ? a : b);
          todayMenus = pastMenus.where((menu) => 
            menu.date.year == latestDate.year && 
            menu.date.month == latestDate.month && 
            menu.date.day == latestDate.day
          ).toList();
          print('Test için geçmiş tarihteki menü kullanılıyor: ${latestDate.toString().split(' ')[0]}');
        }
      }
    }

    if (todayMenus.isEmpty) {
      print('Hiç menü bulunamadı, bildirim planlanamıyor');
      return;
    }

    // Kahvaltı menüsünü bul
    final breakfastMenu = todayMenus.firstWhere(
      (menu) => menu.mealType == 'Kahvaltı',
      orElse: () => Menu(
        id: 0,
        cityId: 0,
        mealType: 'Kahvaltı',
        date: today,
        energy: '',
        items: [],
      ),
    );

    // Akşam yemeği menüsünü bul
    final dinnerMenu = todayMenus.firstWhere(
      (menu) => menu.mealType == 'Akşam Yemeği',
      orElse: () => Menu(
        id: 0,
        cityId: 0,
        mealType: 'Akşam Yemeği',
        date: today,
        energy: '',
        items: [],
      ),
    );

    print('Kahvaltı menüsü bulundu: ${breakfastMenu.items.length} yemek');
    print('Akşam yemeği menüsü bulundu: ${dinnerMenu.items.length} yemek');

    // Kahvaltı bildirimleri
    await _scheduleNotification(
      id: 1,
      title: 'Kahvaltı Başladı! 🍳',
      body: 'Bugünün kahvaltı menüsü:\n${_getMenuSummary(breakfastMenu)}',
      scheduledTime: _getTodayAt(7, 0), // 07:00
    );

    await _scheduleNotification(
      id: 2,
      title: 'Kahvaltı Bitmek Üzere! ⏰',
      body: 'Kahvaltı menüsü:\n${_getMenuSummary(breakfastMenu)}\n\nHemen yemekhaneye gidin!',
      scheduledTime: _getTodayAt(11, 15), // 11:15
    );

    // Akşam yemeği bildirimleri
    await _scheduleNotification(
      id: 3,
      title: 'Akşam Yemeği Başladı! 🍽️',
      body: 'Bugünün akşam yemeği menüsü:\n${_getMenuSummary(dinnerMenu)}',
      scheduledTime: _getTodayAt(19, 23), // 19:16
    );

    await _scheduleNotification(
      id: 4,
      title: 'Akşam Yemeği Bitmek Üzere! ⏰',
      body: 'Akşam yemeği menüsü:\n${_getMenuSummary(dinnerMenu)}\n\nHemen yemekhaneye gidin!',
      scheduledTime: _getTodayAt(22, 15), // 22:15
    );

    print('Günlük yemek bildirimleri planlandı');
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
            enableLights: true,
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      print('Bildirim planlandı: $title - ${targetTime.toString()}');
    } catch (e) {
      print('Bildirim planlanırken hata: $e');
      // Eğer exact alarm izni yoksa, inexact mode kullan
      if (e.toString().contains('exact_alarms_not_permitted')) {
        print('Exact alarm izni yok, inexact mode kullanılıyor...');
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
                enableLights: true,
                enableVibration: true,
                playSound: true,
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          print('Inexact bildirim planlandı: $title');
        } catch (e2) {
          print('Inexact bildirim de başarısız: $e2');
        }
      }
    }
  }

  DateTime _getTodayAt(int hour, int minute) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _getMenuSummary(Menu menu) {
    if (menu.items.isEmpty) return 'Menü henüz açıklanmadı';
    
    // Ana yemekleri al (ilk 5 tane)
    final mainItems = menu.items.take(5).map((item) => item.name).toList();
    
    if (mainItems.length <= 3) {
      return mainItems.join(', ');
    } else {
      return '${mainItems.take(3).join(', ')} ve ${mainItems.length - 3} yemek daha';
    }
  }

  Future<void> cancelAllNotifications() async {
    await notifications.cancelAll();
    print('Tüm bildirimler iptal edildi');
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
    print('Bildirimler ${enabled ? 'açıldı' : 'kapatıldı'}');
  }

  // Test bildirimi gönder
  Future<void> sendTestNotification() async {
    await notifications.show(
      999,
      'Test Bildirimi',
      'Yemek bildirimleri çalışıyor!',
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
    );
  }

  // Aktif bildirimleri getir
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pendingNotifications = await notifications.pendingNotificationRequests();
      print('Aktif bildirim sayısı: ${pendingNotifications.length}');
      return pendingNotifications;
    } catch (e) {
      print('Bildirimler getirilirken hata: $e');
      return [];
    }
  }

  // Bildirimleri yeniden planla
  Future<void> rescheduleNotifications(List<Menu> menus) async {
    await cancelAllNotifications();
    await scheduleDailyMealNotifications(menus);
  }
} 