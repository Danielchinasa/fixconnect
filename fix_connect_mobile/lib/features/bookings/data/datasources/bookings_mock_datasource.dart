import 'package:fix_connect_mobile/app/theme/app_colors.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter/material.dart';

// 📚 CONCEPT: Mock Datasources are used during development before a real backend exists.
// The pattern: a class with a private constructor (._()) prevents instantiation —
// all methods are static, so you call them directly: BookingsMockDatasource.getBookings().
// Later, you swap this for a real API datasource with zero changes to presentation code.
class BookingsMockDatasource {
  BookingsMockDatasource._();

  static List<BookingModel> getBookings() => [
    BookingModel(
      id: 'b1',
      artisanId: '1',
      artisanName: 'Emeka Okafor',
      artisanSpecialty: 'Master Plumber',
      artisanInitials: 'EO',
      artisanBadgeColor: AppColors.primaryLight,
      service: 'Pipe Repair',
      scheduledDate: DateTime.now().add(const Duration(days: 2)),
      timeSlot: '10:00 AM',
      address: '14 Broad Street, Lagos Island',
      totalPrice: '₦7,500',
      status: BookingStatus.upcoming,
      notes: 'Kitchen sink has been leaking for 3 days.',
    ),
    BookingModel(
      id: 'b2',
      artisanId: '2',
      artisanName: 'Amina Bello',
      artisanSpecialty: 'Electrician',
      artisanInitials: 'AB',
      artisanBadgeColor: AppColors.secondary,
      service: 'Electrical Wiring',
      scheduledDate: DateTime.now().add(const Duration(days: 5)),
      timeSlot: '2:00 PM',
      address: '5 Victoria Island, Lagos',
      totalPrice: '₦12,000',
      status: BookingStatus.upcoming,
    ),
    BookingModel(
      id: 'b3',
      artisanId: '4',
      artisanName: 'Fatima Musa',
      artisanSpecialty: 'House Cleaner',
      artisanInitials: 'FM',
      artisanBadgeColor: AppColors.primaryLight,
      service: 'Deep Cleaning',
      scheduledDate: DateTime.now().subtract(const Duration(days: 5)),
      timeSlot: '9:00 AM',
      address: '22 Lekki Phase 1, Lagos',
      totalPrice: '₦5,000',
      status: BookingStatus.completed,
    ),
    BookingModel(
      id: 'b4',
      artisanId: '3',
      artisanName: 'Chukwudi Nze',
      artisanSpecialty: 'Carpenter',
      artisanInitials: 'CN',
      artisanBadgeColor: const Color(0xFFFF9500),
      service: 'Furniture Assembly',
      scheduledDate: DateTime.now().subtract(const Duration(days: 12)),
      timeSlot: '11:00 AM',
      address: '8 Ikoyi Crescent, Lagos',
      totalPrice: '₦8,000',
      status: BookingStatus.completed,
    ),
    BookingModel(
      id: 'b5',
      artisanId: '5',
      artisanName: 'Tunde Adeyemi',
      artisanSpecialty: 'Painter',
      artisanInitials: 'TA',
      artisanBadgeColor: AppColors.secondary,
      service: 'Interior Painting',
      scheduledDate: DateTime.now().subtract(const Duration(days: 1)),
      timeSlot: '8:00 AM',
      address: '3 Surulere, Lagos',
      totalPrice: '₦15,000',
      status: BookingStatus.cancelled,
      notes: 'Budget changed. Will reschedule.',
    ),
  ];
}
