import 'package:fix_connect_mobile/core/constants/api_constants.dart';
import 'package:fix_connect_mobile/core/network/api_client.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';

abstract interface class BookingRemoteDataSource {
  /// Returns all bookings for the authenticated customer.
  Future<List<BookingModel>> getMyBookings();

  /// Returns all booking orders assigned to the authenticated artisan.
  Future<List<BookingModel>> getArtisanBookings();

  /// Creates a new booking request.
  /// No price is submitted — the artisan will respond with a quote.
  Future<void> createBooking({
    required String artisanProfileId,
    required String categoryId,
    required String serviceDescription,
    required String scheduledDate,
    required String timeSlot,
    required String address,
    String? notes,
  });

  /// Sends a price quote for a pending booking.
  /// `PATCH /bookings/{id}/quote` — body: `{ "quotedAmount": <number> }`
  Future<void> sendQuote({required String bookingId, required num amount});

  /// Customer accepts the artisan's quote.
  /// `PATCH /bookings/{id}/accept-quote`
  Future<void> acceptQuote({required String bookingId});

  /// Artisan declines an order.
  /// `PATCH /bookings/{id}/status` — body: `{ "status": "DECLINED" }`
  Future<void> declineOrder({required String bookingId});
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  const BookingRemoteDataSourceImpl(this._api);

  final ApiClient _api;

  @override
  Future<List<BookingModel>> getMyBookings() async {
    final response = await _api.get<dynamic>('${ApiConstants.bookings}/my');
    final data = response.data;
    List<dynamic> list;
    if (data is List) {
      list = data;
    } else if (data is Map) {
      list = (data['data'] ?? data['bookings'] ?? []) as List<dynamic>;
    } else {
      list = [];
    }
    return list
        .cast<Map<String, dynamic>>()
        .map(BookingModel.fromJson)
        .toList();
  }

  @override
  Future<List<BookingModel>> getArtisanBookings() async {
    final response = await _api.get<dynamic>(
      '${ApiConstants.bookings}/artisan',
    );
    final data = response.data;
    List<dynamic> list;
    if (data is List) {
      list = data;
    } else if (data is Map) {
      list = (data['data'] ?? data['bookings'] ?? []) as List<dynamic>;
    } else {
      list = [];
    }
    return list
        .cast<Map<String, dynamic>>()
        .map(BookingModel.fromJson)
        .toList();
  }

  @override
  Future<void> createBooking({
    required String artisanProfileId,
    required String categoryId,
    required String serviceDescription,
    required String scheduledDate,
    required String timeSlot,
    required String address,
    String? notes,
  }) async {
    await _api.post<dynamic>(
      ApiConstants.bookings,
      data: {
        'artisanProfileId': artisanProfileId,
        'categoryId': categoryId,
        'serviceDescription': serviceDescription,
        'scheduledDate': scheduledDate,
        'timeSlot': timeSlot,
        'address': address,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    );
  }

  @override
  Future<void> sendQuote({
    required String bookingId,
    required num amount,
  }) async {
    await _api.patch<dynamic>(
      '${ApiConstants.bookings}/$bookingId/quote',
      data: {'quotedAmount': amount},
    );
  }

  @override
  Future<void> acceptQuote({required String bookingId}) async {
    await _api.patch<dynamic>(
      '${ApiConstants.bookings}/$bookingId/accept-quote',
    );
  }

  @override
  Future<void> declineOrder({required String bookingId}) async {
    await _api.patch<dynamic>(
      '${ApiConstants.bookings}/$bookingId/status',
      data: {'status': 'DECLINED'},
    );
  }
}
