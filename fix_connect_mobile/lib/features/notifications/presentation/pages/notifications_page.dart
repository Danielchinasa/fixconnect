import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/app_spacing.dart';
import 'package:fix_connect_mobile/app/theme/app_text_styles.dart';
import 'package:fix_connect_mobile/core/utils/build_context_ext.dart';
import 'package:fix_connect_mobile/features/notifications/data/datasources/notifications_mock_datasource.dart';
import 'package:fix_connect_mobile/features/notifications/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final List<NotificationModel> _notifications =
      NotificationsMockDatasource.getNotifications();

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  void _markAllRead() =>
      setState(() { for (final n in _notifications) n.isRead = true; });

  void _markRead(String id) => setState(
      () => _notifications.firstWhere((n) => n.id == id).isRead = true);

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  String _timeLabel(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  List<NotificationModel> get _today =>
      _notifications.where((n) => _isToday(n.time)).toList();
  List<NotificationModel> get _earlier =>
      _notifications.where((n) => !_isToday(n.time)).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textColor = context.textColor;
    final bgColor = context.bgColor;
    final primary = context.primary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Notifications', style: AppTextStyles.header4Bold(color: textColor)),
              if (_unreadCount > 0)
                Text('$_unreadCount unread',
                    style: AppTextStyles.bodySmallRegular(color: primary)),
            ],
          ),
          actions: [
            if (_unreadCount > 0)
              TextButton(
                onPressed: _markAllRead,
                child: Text('Mark all read',
                    style: AppTextStyles.bodySmallSemibold(color: primary)),
              ),
          ],
        ),
        body: _notifications.isEmpty
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.notifications_none_rounded,
                      size: 56, color: primary.withValues(alpha: 0.3)),
                  AppGaps.h16,
                  Text('No notifications yet',
                      style: AppTextStyles.bodyMediumRegular(
                          color: textColor.withValues(alpha: 0.5))),
                ]),
              )
            : ListView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 16),
                children: [
                  if (_today.isNotEmpty) ...[
                    _SectionLabel(label: 'Today', textColor: textColor),
                    ..._today.map((n) => _NotifTile(
                          notification: n,
                          timeLabel: _timeLabel(n.time),
                          onTap: () => _markRead(n.id),
                        )),
                  ],
                  if (_earlier.isNotEmpty) ...[
                    _SectionLabel(label: 'Earlier', textColor: textColor),
                    ..._earlier.map((n) => _NotifTile(
                          notification: n,
                          timeLabel: _timeLabel(n.time),
                          onTap: () => _markRead(n.id),
                        )),
                  ],
                ],
              ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color textColor;

  const _SectionLabel({required this.label, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.custom16, AppSpacing.custom16,
          AppSpacing.custom16, AppSpacing.custom8),
      child: Text(label,
          style: AppTextStyles.bodySmallSemibold(
              color: textColor.withValues(alpha: 0.5))),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotificationModel notification;
  final String timeLabel;
  final VoidCallback onTap;

  const _NotifTile(
      {required this.notification,
      required this.timeLabel,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textColor = context.textColor;
    final surfaceColor = context.surfaceColor;
    final primary = context.primary;
    final isDark = context.isDark;
    final typeColor = notification.type.color;
    final unread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: AppSpacing.custom16, vertical: AppSpacing.custom4),
        padding: EdgeInsets.all(AppSpacing.custom14),
        decoration: BoxDecoration(
          color: unread
              ? primary.withValues(alpha: isDark ? 0.08 : 0.05)
              : surfaceColor,
          borderRadius: BorderRadius.circular(AppSpacing.custom16),
          border: unread
              ? Border.all(color: primary.withValues(alpha: 0.2), width: 1)
              : null,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.15),
                shape: BoxShape.circle),
            child: Icon(notification.type.icon, color: typeColor, size: 20),
          ),
          SizedBox(width: AppSpacing.custom12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: unread
                        ? AppTextStyles.bodyMediumBold(color: textColor)
                        : AppTextStyles.bodyMediumMedium(color: textColor),
                  ),
                ),
                if (unread)
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: primary, shape: BoxShape.circle)),
              ]),
              const SizedBox(height: 4),
              Text(notification.body,
                  style: AppTextStyles.bodySmallRegular(
                      color: textColor.withValues(alpha: 0.6)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(timeLabel,
                  style: AppTextStyles.bodySmallRegular(
                      color: textColor.withValues(alpha: 0.4))),
            ]),
          ),
        ]),
      ),
    );
  }
}
