import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/cast_section.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_details_actions.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_details_content.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_genres.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_poster.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_summary.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/similar_movies.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/size_utils.dart';
import '../../widgets/customErrorWidget.dart';
import '../../widgets/customLoadingWidget.dart';
import '../home/tabs/home_tab/widget/movie_gradient.dart';
import 'cubit/details_stats.dart';
import 'cubit/details_view_model.dart';
import 'movies_web_view.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  DetailsViewModel detailsViewModel = DetailsViewModel();
  SuggestionsViewModel suggestionsViewModel = SuggestionsViewModel();
  bool isSelected = false;

  @override
  void dispose() {
    detailsViewModel.close();
    suggestionsViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesId = ModalRoute.of(context)!.settings.arguments as int;
    final width = context.width;
    final height = context.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              BlocProvider(
                create: (context) =>
                    detailsViewModel
                      ..getMovieDetailsBySourceId(sourceId: moviesId),
                child: BlocBuilder<DetailsViewModel, DetailsStats>(
                  builder: (context, state) {
                    if (state is MovieDetailsSuccess) {
                      final details = state.movie.movie!;
                      return Column(
                        children: [
                          Stack(
                            children: [
                              MoviePoster(
                                imageUrl: details.mediumCoverImage ?? '',
                              ),
                              const MovieGradient(),
                              Positioned(
                                top: height * .25,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Image.asset(
                                      AppAssets.playVideo,
                                      width: 97,
                                      height: 97,
                                    ),
                                  ),
                                ),
                              ),
                              MovieDetailsActions(
                                isSelected: isSelected,
                                onBackTap: () {
                                  Navigator.pop(context);
                                },
                                onBookmarkTap: () {
                                  setState(() {
                                    isSelected = !isSelected;
                                  });
                                },
                              ),
                              MovieDetailsContent(
                                details: details,
                                onPressedWatch: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MoviesWebView(
                                          movieDetails: details,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    if (state is MovieDetailsError) {
                      return CustomErrorWidget(
                        error: state.errorMessage,
                        onRetry: () {
                          detailsViewModel.getMovieDetailsBySourceId(
                            sourceId: moviesId,
                          );
                        },
                      );
                    }
                    return CustomLoadingWidget();
                  },
                ),
              ),
              SizedBox(height: height * .016),
              BlocProvider(
                create: (context) => suggestionsViewModel..getMovieSuggestions(sourceId: moviesId),
                child: BlocBuilder<SuggestionsViewModel, SuggestionsStats>(
                  builder: (context, state) {
                    if (state is MovieSuggestionsSuccess) {
                      var movie = state.movies;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * .02),
                        child: Column(
                          children: [
                            SimilarMovies(
                              movies: movie,
                              onMovieTap: (movie) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.detailsRouteName,
                                  arguments: movie.id,
                                );
                              },
                            ),

                            BlocProvider.value(
                              value: detailsViewModel,
                              child:
                                  BlocBuilder<DetailsViewModel, DetailsStats>(
                                    builder: (context, detailsState) {
                                      if (detailsState is MovieDetailsSuccess) {
                                        final details = detailsState.movie.movie!;
                                        return Column(
                                          children: [
                                            MovieSummary(
                                              summary:
                                                  details.descriptionFull ?? "",
                                            ),

                                            SizedBox(height: height * .016),
                                            CastSection(
                                              cast: details.cast ?? [],
                                              width: width,
                                              height: height,
                                            ),
                                            MovieGenres(
                                              genres: details.genres ?? [],
                                            ),

                                            SizedBox(height: height * .01),
                                          ],
                                        );
                                      }

                                      return CustomLoadingWidget();
                                    },
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is MovieSuggestionsError) {
                      return CustomErrorWidget(
                        error: state.errorMessage,
                        onRetry: () {
                          suggestionsViewModel.getMovieSuggestions(
                            sourceId: moviesId,
                          );
                        },
                      );
                    }

                    return CustomLoadingWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
