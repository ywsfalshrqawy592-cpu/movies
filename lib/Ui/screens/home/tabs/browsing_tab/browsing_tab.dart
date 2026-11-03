import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/customErrorWidget.dart';
import 'package:movies_app/Ui/widgets/customLoadingWidget.dart';
import 'package:movies_app/cubit/browsing_tab/cubit/browse_stats.dart';
import 'package:movies_app/cubit/browsing_tab/cubit/browse_view_model.dart';
import 'package:movies_app/cubit/browsing_tab/widget/browse_movies_grid.dart';
import 'package:movies_app/cubit/browsing_tab/widget/genre_chips.dart';

class BrowsingTab extends StatelessWidget {
  const BrowsingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrowseViewModel()..getMovies('Action'),
      child: BlocBuilder<BrowseViewModel, BrowseStats>(
        builder: (context, state) {
          final viewModel = context.read<BrowseViewModel>();

          return Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                const SizedBox(height: 16),

                GenreChips(
                  selectedGenre: viewModel.selectedGenre,
                  onGenreTap: (genre) => viewModel.getMovies(genre),
                ),

                Expanded(child: _buildBody(state, viewModel)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BrowseStats state, BrowseViewModel viewModel) {
    if (state is BrowseSuccessStats) {
      return BrowseMoviesGrid(movies: state.moviesList);
    }

    if (state is BrowseErrorStats) {
      return CustomErrorWidget(
        error: state.errorMessage,
        onRetry: () => viewModel.getMovies(viewModel.selectedGenre),
      );
    }

    return const CustomLoadingWidget();
  }
}
