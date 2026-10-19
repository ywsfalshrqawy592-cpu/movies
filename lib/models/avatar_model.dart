import 'package:movies_app/utils/app_assets.dart';

class AvatarModel {
  final int id;
  final String image;

  const AvatarModel({required this.id, required this.image});

  static final List<AvatarModel> avatars = List.generate(
    AppAssets.profileAvatars.length,
        (index) => AvatarModel(id: index, image: AppAssets.profileAvatars[index]),
  );
}