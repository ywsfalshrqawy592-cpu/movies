import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_details_actions.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_details_content.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_genres.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_poster.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/movie_summary.dart';
import 'package:movies_app/Ui/screens/movie_details/widget/similar_movies.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import '../../../utils/app_routes.dart';
import '../../../utils/size_utils.dart';
import '../../widgets/customErrorWidget.dart';
import '../../widgets/customLoadingWidget.dart';
import '../home/tabs/home_tab/widget/movie_gradient.dart';
import 'cubit/details_stats.dart';
import 'cubit/details_view_model.dart';

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
              BlocProvider(create: (context) => detailsViewModel..getMovieDetailsBySourceId(sourceId: moviesId),
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
                                onPressedWatch: () {},
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
                create: (context) =>
                    suggestionsViewModel..getMovieSuggestions(sourceId: moviesId),
                child: BlocBuilder<SuggestionsViewModel, SuggestionsStats>(
                  builder: (context, state) {
                    if (state is MovieSuggestionsSuccess) {
                      var movie = state.movies;
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * .02),
                        child: Column(
                          children: [
                            SimilarMovies(
                              movies: state.movies,
                              onMovieTap: (movie) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.detailsRouteName,
                                  arguments: movie.id,
                                );
                              },
                            ),
                            MovieSummary(
                              summary: movie.first.descriptionFull ?? "",
                            ),
                            MovieGenres(genres: movie.first.genres ?? []),
                            SizedBox(height: height * .01),
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
