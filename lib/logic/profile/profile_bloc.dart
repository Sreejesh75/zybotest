import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/data/models/user_model.dart';
import 'package:zybo_test/repository/apiservices/profile_api_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileLoading()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await repository.fetchProfile();
        emit(ProfileLoaded(profile));
      } catch (e) {
        emit(ProfileError("Failed to load profile"));
      }
    });
  }
}
