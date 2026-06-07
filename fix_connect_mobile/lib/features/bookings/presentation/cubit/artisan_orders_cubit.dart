import 'package:fix_connect_mobile/core/errors/exceptions.dart';
import 'package:fix_connect_mobile/features/bookings/data/datasources/booking_remote_datasource.dart';
import 'package:fix_connect_mobile/features/bookings/data/models/booking_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class ArtisanOrdersState {
  const ArtisanOrdersState();
}

class ArtisanOrdersInitial extends ArtisanOrdersState {
  const ArtisanOrdersInitial();
}

class ArtisanOrdersLoading extends ArtisanOrdersState {
  const ArtisanOrdersLoading();
}

class ArtisanOrdersLoaded extends ArtisanOrdersState {
  const ArtisanOrdersLoaded(this.orders);
  final List<BookingModel> orders;
}

class ArtisanOrdersError extends ArtisanOrdersState {
  const ArtisanOrdersError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class ArtisanOrdersCubit extends Cubit<ArtisanOrdersState> {
  ArtisanOrdersCubit(this._dataSource) : super(const ArtisanOrdersInitial());

  final BookingRemoteDataSource _dataSource;

  Future<void> load() async {
    emit(const ArtisanOrdersLoading());
    try {
      final orders = await _dataSource.getArtisanBookings();
      emit(ArtisanOrdersLoaded(orders));
    } on UnauthorizedException {
      emit(const ArtisanOrdersError('Session expired. Please log in again.'));
    } on ServerException catch (e) {
      emit(ArtisanOrdersError(e.message));
    } on NetworkException catch (e) {
      emit(ArtisanOrdersError(e.message));
    } catch (e) {
      emit(ArtisanOrdersError(e.toString()));
    }
  }
}
