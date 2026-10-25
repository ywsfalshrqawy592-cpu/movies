import 'package:flutter/material.dart';
import 'package:movies_app/Ui/widgets/app_network_image.dart';
import 'package:movies_app/Ui/widgets/info_chip.dart';
import 'package:movies_app/Ui/widgets/movie_card.dart';

import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

import '../../../model/movie_details_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, this.movie = MovieDetailsModel.sample});

  final MovieDetailsModel movie;

  @override
  Widget build(BuildContext context) {
    final vGap = SizedBox(height: context.height * 0.02);
    final hGap = SizedBox(width: context.width * 0.03);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _PosterHeader(posterUrl: movie.posterUrl),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + year
                  Center(
                    child: Column(
                      children: [
                        Text(
                          movie.title,
                          textAlign: TextAlign.center,
                          style: AppStyles.bold24White,
                        ),
                        SizedBox(height: context.height * 0.008),
                        Text(
                          '${movie.year}',
                          style: AppStyles.regular16White.copyWith(
                            color: AppColors.grayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  vGap,

                  // Watch button
                  SizedBox(
                    width: double.infinity,
                    height: context.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text('Watch', style: AppStyles.bold20White),
                    ),
                  ),
                  vGap,

                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: InfoChip(icon: Icons.favorite, label: '${movie.likes}'),
                      ),
                      hGap,
                      Expanded(
                        child: InfoChip(icon: Icons.access_time_filled, label: '${movie.runtime}'),
                      ),
                      hGap,
                      Expanded(
                        child: InfoChip(icon: Icons.star, label: '${movie.rating}'),
                      ),
                    ],
                  ),
                  vGap,

                  _Section(
                    title: 'Screen Shots',
                    child: Column(
                      children: [
                        for (final url in movie.screenshots)
                          Padding(
                            padding: EdgeInsets.only(bottom: context.height * 0.015),
                            child: AppNetworkImage(
                              url: url,
                              width: double.infinity,
                              height: context.height * 0.17,
                              borderRadius: 16,
                            ),
                          ),
                      ],
                    ),
                  ),

                  _Section(
                    title: 'Similar',
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: movie.similar.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: context.width * 0.03,
                        mainAxisSpacing: context.width * 0.03,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (_, i) => MovieCard(
                        posterUrl: movie.similar[i].posterUrl,
                        rating: movie.similar[i].rating,
                      ),
                    ),
                  ),

                  _Section(
                    title: 'Summary',
                    child: Text(
                      movie.summary,
                      style: AppStyles.regular16White.copyWith(height: 1.4),
                    ),
                  ),

                  _Section(
                    title: 'Cast',
                    child: Column(
                      children: [
                        for (final member in movie.cast)
                          Padding(
                            padding: EdgeInsets.only(bottom: context.height * 0.012),
                            child: _CastTile(member: member),
                          ),
                      ],
                    ),
                  ),

                  _Section(
                    title: 'Genres',
                    child: Wrap(
                      spacing: context.width * 0.03,
                      runSpacing: context.height * 0.012,
                      children: [for (final g in movie.genres) InfoChip(label: g)],
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

/// Poster + back/bookmark buttons + play button + fade into the background.
class _PosterHeader extends StatelessWidget {
  const _PosterHeader({required this.posterUrl});

  final String posterUrl;

  @override
  Widget build(BuildContext context) {
    final height = context.height * 0.5;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: posterUrl, width: double.infinity, height: height),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
                colors: [AppColors.transparentColor, AppColors.backgroundColor],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border_rounded,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: IconButton(
              onPressed: () {},
              iconSize: context.width * 0.2,
              icon: const Icon(
                Icons.play_circle_fill_rounded,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title + content.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppStyles.bold24White),
        SizedBox(height: context.height * 0.015),
        child,
        SizedBox(height: context.height * 0.025),
      ],
    );
  }
}

class _CastTile extends StatelessWidget {
  const _CastTile({required this.member});

  final CastMember member;

  Widget _line(String label, String value) => Text.rich(
    TextSpan(
      children: [
        TextSpan(text: '$label : ', style: AppStyles.bold16White),
        TextSpan(text: value, style: AppStyles.regular16White),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final avatar = context.width * 0.2;
    return Container(
      padding: EdgeInsets.all(context.width * 0.025),
      decoration: BoxDecoration(
        color: AppColors.fieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          AppNetworkImage(
            url: member.imageUrl,
            width: avatar,
            height: avatar,
            borderRadius: 12,
          ),
          SizedBox(width: context.width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line('Name', member.name),
                SizedBox(height: context.height * 0.006),
                _line('Character', member.character),
              ],
            ),
          ),
        ],
      ),
    );
  }
}