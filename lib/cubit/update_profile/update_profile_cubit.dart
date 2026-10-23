import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/models/avatar_model.dart';

import 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileState());

  void selectAvatar(AvatarModel avatar) {
    emit(UpdateProfileState(selectedAvatar: avatar));
  }
}