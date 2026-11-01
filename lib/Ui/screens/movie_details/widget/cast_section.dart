import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../api/model/movie_details/movie_cast_codel.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_styles.dart';

class CastSection extends StatelessWidget {
  const CastSection({
    super.key,
    required this.cast,
    required this.width,
    required this.height,
  });

  final List<MovieCast> cast;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Cast",
            style: AppStyles.bold24White,
          ),
        ),

        ...List.generate(cast.length, (index) {
          return CastItem(
            actorData: cast[index],
            width: width,
            height: height,
          );
        }),
      ],
    );
  }
}

class CastItem extends StatelessWidget {
  const CastItem({
    super.key,
    required this.actorData,
    required this.width,
    required this.height,
  });

  final MovieCast actorData;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: height * .01,
      ),
      width: double.infinity,
      height: 92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.darkFieldColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 11,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                height: 70,
                width: 70,
                imageUrl: actorData.urlSmallImage ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                ),
                errorWidget: (context, url, error) =>
                const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(width: width * .03),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actorData.name ?? "Unknown",
                    style: AppStyles.bold16White,
                  ),

                  SizedBox(height: height * .005),

                  Text(
                    actorData.characterName ??
                        "Unknown Character",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}