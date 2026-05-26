import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/profile/data/models/saved_address.dart';
import 'package:fix_connect_mobile/features/profile/domain/repositories/address_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class AddressState {
  const AddressState();
}

class AddressInitial extends AddressState {
  const AddressInitial();
}

class AddressLoading extends AddressState {
  const AddressLoading();
}

/// Normal loaded state. [loadingId] is set while a single-card action
/// (delete / set-default) is in flight. [isSubmitting] is true while
/// a create/update sheet save is in flight.
class AddressLoaded extends AddressState {
  const AddressLoaded(
    this.addresses, {
    this.loadingId,
    this.isSubmitting = false,
    this.successMessage,
  });

  final List<SavedAddress> addresses;
  final String? loadingId;
  final bool isSubmitting;
  final String? successMessage;

  AddressLoaded copyWith({
    List<SavedAddress>? addresses,
    String? loadingId,
    bool clearLoadingId = false,
    bool? isSubmitting,
    String? successMessage,
  }) => AddressLoaded(
    addresses ?? this.addresses,
    loadingId: clearLoadingId ? null : (loadingId ?? this.loadingId),
    isSubmitting: isSubmitting ?? this.isSubmitting,
    successMessage: successMessage,
  );
}

class AddressError extends AddressState {
  const AddressError(this.message, {this.addresses = const []});

  final String message;
  final List<SavedAddress> addresses;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class AddressCubit extends Cubit<AddressState> {
  AddressCubit(this._repository) : super(const AddressInitial());

  final AddressRepository _repository;

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> load() async {
    emit(const AddressLoading());
    final result = await _repository.getAddresses();
    switch (result) {
      case Ok(:final value):
        emit(AddressLoaded(value));
      case Err(:final failure):
        emit(AddressError(failure.message));
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<void> create({
    required String label,
    required String address,
    required String city,
    required String province,
    bool isDefault = false,
  }) async {
    final current = state;
    final prev = current is AddressLoaded
        ? current.addresses
        : const <SavedAddress>[];
    if (current is AddressLoaded) {
      emit(current.copyWith(isSubmitting: true));
    }

    final result = await _repository.createAddress(
      label: label,
      address: address,
      city: city,
      state: province,
      isDefault: isDefault,
    );

    switch (result) {
      case Ok(:final value):
        final (address, message) = value;
        // If the new address is default, clear isDefault on all others.
        final updated = [
          if (address.isDefault)
            ...prev.map((a) => a.copyWith(isDefault: false))
          else
            ...prev,
          address,
        ];
        emit(AddressLoaded(updated, successMessage: message));
      case Err(:final failure):
        emit(AddressLoaded(prev));
        emit(AddressError(failure.message, addresses: prev));
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<void> update(
    String id, {
    required String label,
    required String address,
    required String city,
    required String province,
  }) async {
    final current = state;
    final prev = current is AddressLoaded
        ? current.addresses
        : const <SavedAddress>[];
    if (current is AddressLoaded) {
      emit(current.copyWith(isSubmitting: true));
    }

    final result = await _repository.updateAddress(
      id,
      label: label,
      address: address,
      city: city,
      state: province,
    );

    switch (result) {
      case Ok(:final value):
        final (updated_address, message) = value;
        // Replace the edited address in the list; propagate isDefault changes.
        final updated = prev.map((a) {
          if (a.id == updated_address.id) return updated_address;
          return updated_address.isDefault ? a.copyWith(isDefault: false) : a;
        }).toList();
        emit(AddressLoaded(updated, successMessage: message));
      case Err(:final failure):
        emit(AddressLoaded(prev));
        emit(AddressError(failure.message, addresses: prev));
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> delete(String id) async {
    final current = state;
    if (current is! AddressLoaded) return;
    emit(current.copyWith(loadingId: id));

    final result = await _repository.deleteAddress(id);

    switch (result) {
      case Ok(:final value):
        final updated = current.addresses.where((a) => a.id != id).toList();
        emit(AddressLoaded(updated, successMessage: value));
      case Err(:final failure):
        emit(current.copyWith(clearLoadingId: true));
        emit(AddressError(failure.message, addresses: current.addresses));
    }
  }

  // ── Set default ───────────────────────────────────────────────────────────

  Future<void> setDefault(String id) async {
    final current = state;
    if (current is! AddressLoaded) return;
    emit(current.copyWith(loadingId: id));

    final result = await _repository.setDefaultAddress(id);

    switch (result) {
      case Ok(:final value):
        final updated = current.addresses
            .map((a) => a.copyWith(isDefault: a.id == id))
            .toList();
        emit(AddressLoaded(updated, successMessage: value));
      case Err(:final failure):
        emit(current.copyWith(clearLoadingId: true));
        emit(AddressError(failure.message, addresses: current.addresses));
    }
  }
}
