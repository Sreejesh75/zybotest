import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/repository/apiservices/banner_repository.dart';

// Events
abstract class BannerEvent {}

class FetchBanners extends BannerEvent {}

// States
abstract class BannerState {}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List banners;
  BannerLoaded(this.banners);
}

class BannerError extends BannerState {
  final String message;
  BannerError(this.message);
}

// Bloc
class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository repository;
  BannerBloc(this.repository) : super(BannerInitial()) {
    on<FetchBanners>(_onFetchBanners);
  }

  Future<void> _onFetchBanners(
    FetchBanners event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    try {
      final banners = await repository.fetchBanners();
      emit(BannerLoaded(banners));
    } catch (e) {
      emit(BannerError(e.toString()));
    }
  }
}
