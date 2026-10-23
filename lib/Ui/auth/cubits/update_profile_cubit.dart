import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/auth/auth_failure.dart';
import 'package:movies_app/Ui/auth/auth_service.dart';
import 'package:movies_app/Ui/auth/auth_user.dart';
import 'package:movies_app/utils/app_prefs.dart';

/// Status of the profile update request.
enum UpdateProfileStatus { idle, submitting, success, failure }

class UpdateProfileState {
  const UpdateProfileState({
    this.status = UpdateProfileStatus.idle,
    this.user,
    this.failure,
  });

  final UpdateProfileStatus status;
  final AppUser? user;
  final AuthFailure? failure;

  bool get isSubmitting => status == UpdateProfileStatus.submitting;

  bool get isSuccess => status == UpdateProfileStatus.success;

  bool get hasFailed => status == UpdateProfileStatus.failure;
}

/// Saves the editable profile data.
///
/// Name and avatar live in the Firebase profile (so they follow the account).
/// The phone number has no provider field, so it is kept in the existing local
/// preferences utility.
class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit(this._service) : super(const UpdateProfileState());

  final AuthService _service;

  Future<void> update({
    required String name,
    required String phone,
    required String avatarPath,
  }) async {
    if (state.isSubmitting) return;
    emit(const UpdateProfileState(status: UpdateProfileStatus.submitting));
    try {
      final user = await _service.updateProfile(
        name: name,
        photoUrl: avatarPath,
      );
      await AppPrefs.setProfilePhone(phone.trim());
      emit(UpdateProfileState(status: UpdateProfileStatus.success, user: user));
    } on AuthFailure catch (failure) {
      emit(
        UpdateProfileState(
          status: UpdateProfileStatus.failure,
          failure: failure,
        ),
      );
    }
  }
}
