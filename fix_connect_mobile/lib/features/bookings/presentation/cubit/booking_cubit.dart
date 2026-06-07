import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class BookingState {
  const BookingState();
}

class BookingIdle extends BookingState {
  const BookingIdle();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingSuccess extends BookingState {
  const BookingSuccess();
}

class BookingError extends BookingState {
  const BookingError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this._dataSource) : super(const BookingIdle());

  final BookingRemoteDataSource _dataSource;

  Future<void> create({
    required String artisanProfileId,
    required String categoryId,
    required String serviceDescription,
    required String scheduledDate,
    required String timeSlot,
    required String address,
    String? notes,
  }) async {
    emit(const BookingLoading());
    try {
      await _dataSource.createBooking(
        artisanProfileId: artisanProfileId,
        categoryId: categoryId,
        serviceDescription: serviceDescription,
        scheduledDate: scheduledDate,
        timeSlot: timeSlot,
        address: address,
        notes: notes,
      );
      emit(const BookingSuccess());
    } on UnauthorizedException {
      emit(const BookingError('Session expired. Please log in again.'));
    } on ServerException catch (e) {
      emit(BookingError(e.message));
    } on NetworkException catch (e) {
      emit(BookingError(e.message));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  void reset() => emit(const BookingIdle());
}
