import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/Ui/screens/movie_details/movie_details_screen.dart';
import 'package:movies_app/Ui/screens/search/search_movie.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';

const double _maxContentWidth = 430;
const double _horizontalPadding = 16;
const double _searchFieldHeight = 56;
const double _emptyBottomNavHeight = 56;
const double _emptyBottomNavMargin = 14;
const double _resultsBottomNavHeight = 61;
const double _resultsBottomNavMargin = 9;
const double _cardAspectRatio = 191 / 279;
const Color _ratingBadgeColor = Color(0xB5121312);
const Color _mutedTextColor = Color(0xFFADADAD);

/// Searches movies for the search field.
///
/// The default implementation filters [searchCatalog]. A real data source can
/// pass its own callback without changing the screen's layout or states.
typedef SearchMovies = Future<List<SearchMovie>> Function(String query);

/// Search screen with the initial empty state and the result states.
///
/// The Figma frame uses a fixed search field, a scrollable poster grid, and a
/// floating bottom navigation bar. The same structure is used for the empty,
/// loading, no-result, and error states.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.search});

  final SearchMovies? search;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _debounce;
  List<SearchMovie> _results = const [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _error;
  int _requestId = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();

    if (query.isEmpty) {
      _requestId++;
      setState(() {
        _results = const [];
        _isLoading = false;
        _hasSearched = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _error = null;
    });

    _debounce = Timer(const Duration(milliseconds: 320), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    final requestId = ++_requestId;

    try {
      final movies = widget.search == null
          ? searchCatalog
                .where((movie) => movie.matches(query))
                .toList(growable: false)
          : await widget.search!(query);

      if (!mounted ||
          requestId != _requestId ||
          _controller.text.trim() != query) {
        return;
      }

      setState(() {
        _results = movies;
        _isLoading = false;
        _hasSearched = true;
        _error = null;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;

      setState(() {
        _results = const [];
        _isLoading = false;
        _hasSearched = true;
        _error = 'Something went wrong. Please try again.';
      });
    }
  }

  void _onSubmitted(String value) {
    _debounce?.cancel();
    final query = value.trim();

    if (query.isEmpty) {
      _onQueryChanged('');
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _error = null;
    });
    _search(query);
  }

  void _retry() {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    _search(query);
  }

  void _openMovie(SearchMovie movie) {
    _focusNode.unfocus();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MovieDetailsScreen(movie: movie.toDetails()),
      ),
    );
  }

  void _goHome() {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.popUntil((route) => route.isFirst);
    } else {
      navigator.pushReplacementNamed(AppRoutes.homeRouteName);
    }
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        _goHome();
        return;
      case 1:
        _focusNode.requestFocus();
        return;
      case 2:
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Watchlist is not available yet.')),
          );
        return;
      case 3:
        _focusNode.unfocus();
        Navigator.of(context).pushNamed(AppRoutes.updateProfileRouteName);
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final showingResults =
        !_isLoading && _error == null && _hasSearched && _results.isNotEmpty;
    final navHeight = showingResults
        ? _resultsBottomNavHeight
        : _emptyBottomNavHeight;
    final navMargin = showingResults
        ? _resultsBottomNavMargin
        : _emptyBottomNavMargin;
    final reservedBottom = navHeight + navMargin + bottomInset;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.darkBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.darkBackgroundColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = math.min(
              constraints.maxWidth,
              _maxContentWidth,
            );

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              _horizontalPadding,
                              21,
                              _horizontalPadding,
                              0,
                            ),
                            child: _SearchField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onChanged: _onQueryChanged,
                              onSubmitted: _onSubmitted,
                            ),
                          ),
                          Expanded(child: _buildContent(reservedBottom)),
                        ],
                      ),
                      Positioned(
                        left: 9,
                        right: 8,
                        bottom: navMargin + bottomInset,
                        child: _BottomNav(
                          height: navHeight,
                          selectedIndex: 1,
                          onTap: _onNavTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(double reservedBottom) {
    if (_isLoading) {
      return Padding(
        padding: EdgeInsets.only(bottom: reservedBottom),
        child: const Center(
          key: Key('searchLoading'),
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    if (_error != null) {
      return _ErrorState(
        message: _error!,
        bottomPadding: reservedBottom,
        onRetry: _retry,
      );
    }

    if (!_hasSearched) {
      return Padding(
        padding: EdgeInsets.only(bottom: reservedBottom),
        child: const Center(
          key: Key('searchEmptyState'),
          child: Padding(
            padding: EdgeInsets.only(bottom: 7),
            child: _PopcornIllustration(),
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: reservedBottom),
        child: Center(
          key: const Key('searchNoResults'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PopcornIllustration(),
                const SizedBox(height: 20),
                Text(
                  'No movies found',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Try a different title or genre.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: _mutedTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _ResultsGrid(
      movies: _results,
      bottomPadding: reservedBottom + 12,
      onMovieTap: _openMovie,
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.roboto(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: AppColors.whiteColor,
    );

    return SizedBox(
      height: _searchFieldHeight,
      child: TextField(
        key: const Key('searchField'),
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTapOutside: (_) => focusNode.unfocus(),
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: textStyle,
        cursorColor: AppColors.primaryColor,
        cursorHeight: 24,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.darkFieldColor,
          hintText: 'Search',
          hintStyle: textStyle,
          contentPadding: const EdgeInsets.only(top: 16, bottom: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.search, size: 24, color: AppColors.whiteColor),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 59,
            minHeight: 24,
          ),
        ),
      ),
    );
  }
}

class _ResultsGrid extends StatelessWidget {
  const _ResultsGrid({
    required this.movies,
    required this.bottomPadding,
    required this.onMovieTap,
  });

  final List<SearchMovie> movies;
  final double bottomPadding;
  final ValueChanged<SearchMovie> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      key: const Key('searchResultsGrid'),
      padding: EdgeInsets.fromLTRB(
        _horizontalPadding,
        12,
        _horizontalPadding,
        bottomPadding,
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 8,
        childAspectRatio: _cardAspectRatio,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _MovieCard(movie: movie, onTap: () => onMovieTap(movie));
      },
    );
  }
}

class _MovieCard extends StatelessWidget {
  const _MovieCard({required this.movie, required this.onTap});

  final SearchMovie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${movie.title}, rating ${movie.rating.toStringAsFixed(1)}',
      child: GestureDetector(
        key: ValueKey('searchMovie_${movie.title}'),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                movie.posterAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.darkFieldColor,
                  child: Icon(
                    Icons.movie_outlined,
                    color: AppColors.grayColor,
                    size: 40,
                  ),
                ),
              ),
              Positioned(
                top: 13,
                left: 10,
                child: _RatingBadge(rating: movie.rating),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: _ratingBadgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1,
              color: AppColors.whiteColor,
            ),
          ),
          const SizedBox(width: 6),
          Image.asset(AppAssets.movieDetailsRatingStar, width: 15, height: 15),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.height,
    required this.selectedIndex,
    required this.onTap,
  });

  final double height;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('searchBottomNav'),
      height: height,
      decoration: BoxDecoration(
        color: AppColors.darkFieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: height == _emptyBottomNavHeight ? 5 : 0),
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: Icons.home_outlined,
                size: 26,
                semanticLabel: 'Home',
                selected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.search,
                size: 24,
                semanticLabel: 'Search',
                selected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.bookmark_border,
                size: 23,
                semanticLabel: 'Watchlist',
                selected: selectedIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.person_outline,
                size: 23,
                semanticLabel: 'Profile',
                selected: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.size,
    required this.semanticLabel,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final String semanticLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Icon(
              icon,
              size: size,
              color: selected ? AppColors.primaryColor : AppColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.bottomPadding,
    required this.onRetry,
  });

  final String message;
  final double bottomPadding;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Center(
        key: const Key('searchError'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 56,
                color: AppColors.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onRetry,
                child: Text(
                  'Try again',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopcornIllustration extends StatelessWidget {
  const _PopcornIllustration();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 124,
      height: 124,
      child: CustomPaint(painter: _PopcornPainter()),
    );
  }
}

/// Small flat popcorn-and-drink illustration used by the empty states.
class _PopcornPainter extends CustomPainter {
  const _PopcornPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 124;
    canvas.save();
    canvas.scale(scale);

    final yellow = Paint()..color = AppColors.primaryColor;
    final white = Paint()..color = AppColors.whiteColor;
    final softWhite = Paint()..color = const Color(0x66FFFFFF);

    // Straw behind the drink cup.
    final straw = Paint()
      ..color = AppColors.whiteColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(99, 29), const Offset(103, 62), straw);

    final strawHighlight = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      const Offset(99, 29),
      const Offset(101, 44),
      strawHighlight,
    );

    // Drink cup.
    final cup = Path()
      ..moveTo(85, 62)
      ..lineTo(108, 62)
      ..lineTo(104, 108)
      ..quadraticBezierTo(104, 112, 100, 112)
      ..lineTo(93, 112)
      ..quadraticBezierTo(89, 112, 89, 108)
      ..close();
    canvas.drawPath(cup, yellow);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(83, 57, 27, 9),
        const Radius.circular(4.5),
      ),
      white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(91, 72, 12, 5),
        const Radius.circular(2.5),
      ),
      softWhite,
    );

    // Popcorn bucket.
    final bucket = Path()
      ..moveTo(31, 64)
      ..lineTo(83, 64)
      ..lineTo(77, 109)
      ..quadraticBezierTo(76.5, 113, 72.5, 113)
      ..lineTo(41.5, 113)
      ..quadraticBezierTo(37.5, 113, 37, 109)
      ..close();
    canvas.drawPath(bucket, yellow);

    // White rim and subtle bucket stripes.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(28, 57, 58, 10),
        const Radius.circular(5),
      ),
      white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(44, 70, 4, 35),
        const Radius.circular(2),
      ),
      softWhite,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(67, 70, 4, 35),
        const Radius.circular(2),
      ),
      softWhite,
    );

    // White circle on the front of the bucket.
    canvas.drawCircle(const Offset(56, 92), 13, white);

    // Popcorn cluster.
    const kernels = <Offset>[
      Offset(38, 51),
      Offset(48, 42),
      Offset(60, 36),
      Offset(72, 41),
      Offset(80, 51),
      Offset(43, 58),
      Offset(56, 52),
      Offset(68, 54),
      Offset(75, 60),
      Offset(50, 61),
    ];
    const radii = <double>[9, 9, 10, 9, 8, 8, 9, 8, 7, 7];
    for (var index = 0; index < kernels.length; index++) {
      canvas.drawCircle(kernels[index], radii[index], yellow);
    }

    canvas.drawCircle(const Offset(47, 42), 3, softWhite);
    canvas.drawCircle(const Offset(70, 41), 3, softWhite);
    canvas.drawCircle(const Offset(61, 55), 2.5, softWhite);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
