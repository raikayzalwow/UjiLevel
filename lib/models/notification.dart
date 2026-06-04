class AppNotification {
  final String id;
  final String type; // 'promo' or 'transaction'
  final String title;
  final String message;
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
  });
}
