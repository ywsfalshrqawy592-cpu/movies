import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/screens/home/tabs/home_tab/widget/latest_movies_carousel.dart';
import 'package:movies_app/Ui/screens/home/tabs/home_tab/widget/movie_card.dart';
import 'package:movies_app/Ui/screens/home/tabs/home_tab/widget/movie_gradient.dart';
import 'package:movies_app/Ui/screens/home/tabs/home_tab/widget/section_header.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_routes.dart';
import '../../../../../utils/app_assets.dart';
import '../../../../../utils/size_utils.dart';
import '../../../../widgets/customErrorWidget.dart';
import '../../../../widgets/customLoadingWidget.dart';
import 'cubit/home_stats.dart';
import 'cubit/home_view_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentCarouselIndex = 0;
  HomeViewModel homeViewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => homeViewModel..getMovies(),
      child: BlocBuilder<HomeViewModel, HomeStats>(
        builder: (context, state) {
          if (state is HomeSuccessStats) {
            final movies = state.moviesList;
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: height * .65,
                  child: CachedNetworkImage(
                    imageUrl:
                        movies[_currentCarouselIndex].mediumCoverImage ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.white),
                  ),
                ),
                const MovieGradient(),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * .008),
                      Center(
                        child: Image.asset(
                          AppAssets.availableNow,
                          width: width * .82,
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(height: height * .02),

                      LatestMoviesCarousel(
                        movies: movies,
                        imagePath: (movies) => movies.mediumCoverImage ?? '',
                        rating: (movies) => movies.rating?.toDouble() ?? 0.0,
                        title: (movies) => movies.title ?? '',
                        height: height * .38,
                        viewportFraction: .55,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentCarouselIndex = index;
                          });
                        },
                        onMovieTap: (movie) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.detailsRouteName,
                            arguments: movie.id,
                          );

                        },
                      ),
                      SizedBox(height: height * .01),
                      Center(
                        child: Image.asset(
                          AppAssets.watchNow,
                          width: width * .9,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SectionHeader(
                        seeMoreText: l10n.homeSeeMore,
                        title: l10n.homeActionGenre,
                        onSeeMoreTap: () {},
                      ),
                      SizedBox(height: height * .02),
                      SizedBox(
                        height: height * .25,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * .037,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: width * .037),
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return MovieCard(
                              widthCard: 146,
                              heightCard: 220,
                              imagePath: movie.mediumCoverImage ?? '',
                              rating: movie.rating?.toDouble() ?? 0.0,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.detailsRouteName,
                                  arguments: movie.id,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          if (state is HomeErrorStats) {
            return CustomErrorWidget(
              error: state.errorMessage,
              onRetry: () {
                homeViewModel.getMovies();
              },
            );
          }
          return CustomLoadingWidget();
        },
      ),
    );
  }
}
