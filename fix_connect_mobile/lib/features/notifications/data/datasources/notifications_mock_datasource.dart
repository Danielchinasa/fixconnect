import 'package:fix_connect_mobile/features/notifications/data/models/notification_model.dart';

class NotificationsMockDatasource {
  NotificationsMockDatasource._();

  static List<NotificationModel> getNotifications() => [
    NotificationModel(
      id: 'n1',
      type: NotificationType.bookingConfirmed,
      title: 'Booking Confirmed!',
      body: 'Your booking with Emeka Okafor for Pipe Repair is confirmed for Fri, 25 Apr at 10:00 AM.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n2',
      type: NotificationType.bookingReminder,
      title: 'Booking Tomorrow',
      body: "Don't forget — Amina Bello is coming for Electrical Wiring tomorrow at 2:00 PM.",
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n3',
      type: NotificationType.payment,
      title: 'Payment Successful',
      body: '₦7,500 payment for Pipe Repair was processed successfully.',
      time: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n4',
      type: NotificationType.reviewRequest,
      title: 'How was the service?',
      body: 'Rate your experience with Fatima Musa for Deep Cleaning.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n5',
      type: NotificationType.promo,
      title: '20% off this weekend!',
      body: 'Book any cleaning service this weekend and save 20%. Use code CLEAN20.',
      time: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n6',
      type: NotificationType.bookingConfirmed,
      title: 'Booking Request Sent',
      body: 'Your request with Chukwudi Nze for Furniture Assembly has been sent.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n7',
      type: NotificationType.payment,
      title: 'Refund Processed',
      body: '₦15,000 refund for the cancelled Interior Painting booking is complete.',
      time: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
  ];
}
