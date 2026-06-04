import 'package:flutter/foundation.dart';
import '../models/notification.dart';
import '../services/mock_data_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  List<AppNotification> get todayNotifications {
    final today = DateTime.now();
    return _notifications.where((n) {
      final diff = today.difference(n.createdAt);
      return diff.inHours < 24 && n.createdAt.day == today.day;
    }).toList();
  }

  List<AppNotification> get olderNotifications {
    final today = DateTime.now();
    return _notifications.where((n) {
      final diff = today.difference(n.createdAt);
      return diff.inHours >= 24 || n.createdAt.day != today.day;
    }).toList();
  }

  Future<void> loadNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications = MockDataService.getNotifications();
    notifyListeners();
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void addOrderNotification(String orderId) {
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'transaction',
        title: 'Order confirmed!',
        message: 'Your order $orderId has been confirmed and is being prepared.',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
