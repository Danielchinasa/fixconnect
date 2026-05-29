import 'package:fix_connect_mobile/core/errors/result.dart';
import 'package:fix_connect_mobile/features/home/data/models/service_category_model.dart';
import 'package:fix_connect_mobile/features/home/domain/repositories/services_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class ServicesCubitState {
  const ServicesCubitState();
}

class ServicesInitial extends ServicesCubitState {
  const ServicesInitial();
}

class ServicesLoading extends ServicesCubitState {
  const ServicesLoading();
}

class ServicesLoaded extends ServicesCubitState {
  const ServicesLoaded(this.categories);
  final List<ServiceCategoryModel> categories;
}

class ServicesError extends ServicesCubitState {
  const ServicesError(this.message);
  final String message;
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class ServicesCubit extends Cubit<ServicesCubitState> {
  ServicesCubit(this._repository) : super(const ServicesInitial());

  final ServicesRepository _repository;

  Future<void> load() async {
    emit(const ServicesLoading());
    final result = await _repository.getCategories();
    switch (result) {
      case Ok(:final value):
        emit(ServicesLoaded(value));
      case Err(:final failure):
        emit(ServicesError(failure.message));
    }
  }
}
