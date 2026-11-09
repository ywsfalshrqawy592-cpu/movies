import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/movie_details_actions.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/movie_details_content.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/movie_genres.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/movie_poster.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/movie_summary.dart';
import 'package:movies_app/features/movie_details/presentation/widgets/similar_movies.dart';
import 'package:movies_app/features/watchlist/presentation/cubit/history_cubit.dart';
import 'package:movies_app/features/watchlist/data/saved_movie.dart';
import 'package:movies_app/features/watchlist/presentation/cubit/watch_list_cubit.dart';
import 'package:movies_app/features/watchlist/presentation/cubit/watch_list_state.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/size_utils.dart';
import 'package:movies_app/shared/widgets/custom_error_widget.dart';
import 'package:movies_app/shared/widgets/custom_loading_widget.dart';
import 'package:movies_app/features/home/presentation/widgets/movie_gradient.dart';
import 'package:movies_app/features/movie_details/presentation/screens/movie_web_view_screen.dart';

import '../../new_cubit/movie_details_stats.dart';
import '../../new_cubit/movie_details_view_model.dart';

part 'details_screen_state.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _DetailsScreenState();
}
