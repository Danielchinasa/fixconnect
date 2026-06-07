import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class MyBookingsState {
  const MyBookingsState();
}

class MyBookingsInitial extends MyBookingsState {
  const MyBookingsInitial();
}

class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading();
}

class MyBookingsLoaded extends MyBookingsState {
  const MyBookingsLoaded(this.bookings);
  final List<BookingModel> bookings;
}

class MyBookingsError extends MyBookingsState {
  const MyBookingsError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit(this._dataSource) : super(const MyBookingsInitial());

  final BookingRemoteDataSource _dataSource;

  Future<void> load() async {
    emit(const MyBookingsLoading());
    try {
      final bookings = await _dataSource.getMyBookings();
      emit(MyBookingsLoaded(bookings));
    } on UnauthorizedException {
      emit(const MyBookingsError('Session expired. Please log in again.'));
    } on ServerException catch (e) {
      emit(MyBookingsError(e.message));
    } on NetworkException catch (e) {
      emit(MyBookingsError(e.message));
    } catch (e) {
      emit(MyBookingsError(e.toString()));
    }
  }
}
