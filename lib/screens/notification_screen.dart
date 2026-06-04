import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../providers/notification_provider.dart';
import '../models/notification.dart';
import '../utils/app_theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _localeReady = false;

  @override
  void initState() {
    super.initState();
    _initLocale();
  }

  Future<void> _initLocale() async {
    // FIX 4: Inisialisasi locale id_ID agar DateFormat tidak error
    await initializeDateFormatting('id_ID', null);
    if (mounted) setState(() => _localeReady = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        centerTitle: true,
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                context.read<NotificationProvider>().markAllAsRead(),
            child: const Text(
              'Tandai semua dibaca',
              style: TextStyle(color: AppTheme.primary, fontSize: 13),
            ),
          ),
        ],
      ),
      body: !_localeReady
          ? const Center(child: CircularProgressIndicator())
          : Consumer<NotificationProvider>(
              builder: (ctx, np, _) {
                if (np.notifications.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none,
                            size: 80, color: AppTheme.greyLight),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada notifikasi',
                          style: TextStyle(color: AppTheme.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    if (np.todayNotifications.isNotEmpty) ...[
                      _buildSectionHeader('Hari ini'),
                      ..._buildGroupedNotifications(np.todayNotifications),
                      ...np.todayNotifications
                          .map((n) => _buildNotificationDetail(n)),
                    ],
                    if (np.olderNotifications.isNotEmpty) ...[
                      _buildSectionHeader(
                        'Kemarin, ${DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now().subtract(const Duration(days: 1)))}',
                      ),
                      ..._buildGroupedNotifications(np.olderNotifications),
                      ...np.olderNotifications
                          .map((n) => _buildNotificationDetail(n)),
                    ],
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.grey,
        ),
      ),
    );
  }

  List<Widget> _buildGroupedNotifications(List<AppNotification> notifications) {
    final groups = <String, int>{};
    for (var n in notifications) {
      groups[n.type] = (groups[n.type] ?? 0) + 1;
    }

    return groups.entries.map((entry) {
      final isPromo = entry.key == 'promo';
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isPromo ? const Color(0xFFFFF3E0) : const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isPromo
                    ? Icons.local_offer_outlined
                    : Icons.receipt_long_outlined,
                color: isPromo ? const Color(0xFFFF9800) : AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPromo ? 'Promosi' : 'Transaksi',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),
                  Text(
                    '${entry.value} notifikasi',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                entry.value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.grey, size: 18),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildNotificationDetail(AppNotification n) {
    final isPromo = n.type == 'promo';
    final timeAgo = _getTimeAgo(n.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: n.isRead
            ? AppTheme.white
            : AppTheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: n.isRead
              ? Colors.transparent
              : AppTheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  isPromo ? const Color(0xFFFFF3E0) : const Color(0xFFE0F2F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isPromo
                  ? Icons.local_offer_outlined
                  : Icons.receipt_long_outlined,
              color: isPromo ? const Color(0xFFFF9800) : AppTheme.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPromo ? 'Promosi' : 'Transaksi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isPromo
                            ? const Color(0xFFFF9800)
                            : AppTheme.primary,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style:
                          const TextStyle(fontSize: 11, color: AppTheme.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  n.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  n.message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    // FIX 4: Gunakan locale id_ID agar tidak crash
    return DateFormat('d MMM', 'id_ID').format(dt);
  }
}
