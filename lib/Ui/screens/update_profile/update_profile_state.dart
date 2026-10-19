import 'package:movies_app/models/avatar_model.dart';

class UpdateProfileState {
  final AvatarModel selectedAvatar;

  UpdateProfileState({AvatarModel? selectedAvatar})
      : selectedAvatar = selectedAvatar ?? AvatarModel.avatars.first;
}