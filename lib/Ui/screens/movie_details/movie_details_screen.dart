import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/Ui/screens/movie_details/movie_details_model.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';

const double _designWidth = 430;
const double _horizontalPadding = 16;
const double _maxContentWidth = 600;
const double _posterHeight = 645;
const double _sectionGap = 25;
const double _watchButtonHeight = 58;
const double _statsHeight = 47;
const Color _watchRed = Color(0xFFE82626);
const Color _yearColor = Color(0xFFADADAD);
const Color _ratingBadgeColor = Color(0xB5121312);

const EdgeInsets _horizontal = EdgeInsets.symmetric(
  horizontal: _horizontalPadding,
);

/// Movie details screen.
///
/// The screen is intentionally data-driven: [movie] can be replaced by a real
/// movie from the data layer when that layer is added to this branch. The
/// default value is the content of the Figma frame, used as a preview.
class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, this.movie = MovieDetailsModel.sample});

  final MovieDetailsModel movie;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isBookmarked = true;

  void _showPlaybackMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Playback is not connected to a video source yet.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
            final bottomInset = MediaQuery.paddingOf(context).bottom;

            return Center(
              child: SizedBox(
                width: contentWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PosterHeader(
                        movie: widget.movie,
                        width: contentWidth,
                        isBookmarked: _isBookmarked,
                        onBack: () => Navigator.of(context).maybePop(),
                        onBookmark: () =>
                            setState(() => _isBookmarked = !_isBookmarked),
                        onPlay: _showPlaybackMessage,
                      ),
                      _WatchButton(onPressed: _showPlaybackMessage),
                      const SizedBox(height: 16),
                      _StatsRow(movie: widget.movie),
                      const SizedBox(height: _sectionGap),
                      const _SectionTitle('Screen Shots'),
                      const SizedBox(height: 16),
                      _Screenshots(assets: widget.movie.screenshots),
                      const SizedBox(height: _sectionGap),
                      const _SectionTitle('Similar'),
                      const SizedBox(height: 16),
                      _SimilarGrid(movies: widget.movie.similarMovies),
                      const SizedBox(height: _sectionGap),
                      const _SectionTitle('Summary'),
                      const SizedBox(height: 16),
                      _Summary(summary: widget.movie.summary),
                      const SizedBox(height: _sectionGap),
                      const _SectionTitle('Cast'),
                      const SizedBox(height: 10),
                      _CastList(cast: widget.movie.cast),
                      const SizedBox(height: _sectionGap),
                      const _SectionTitle('Genres'),
                      const SizedBox(height: 10),
                      _Genres(genres: widget.movie.genres),
                      SizedBox(height: 57 + bottomInset),
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
}

/// Poster, gradient, top actions, play button, title and year.
class _PosterHeader extends StatelessWidget {
  const _PosterHeader({
    required this.movie,
    required this.width,
    required this.isBookmarked,
    required this.onBack,
    required this.onBookmark,
    required this.onPlay,
  });

  final MovieDetailsModel movie;
  final double width;
  final bool isBookmarked;
  final VoidCallback onBack;
  final VoidCallback onBookmark;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final height = width * _posterHeight / _designWidth;
    final playSize = (width * 97 / _designWidth).clamp(72.0, 120.0);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(movie.posterAsset, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33121312), AppColors.darkBackgroundColor],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.08),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onPlay,
              child: CustomPaint(
                size: Size.square(playSize),
                painter: const _PlayButtonPainter(),
              ),
            ),
          ),
          Positioned(
            left: _horizontalPadding,
            right: _horizontalPadding,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: _MovieStyles.title,
                  ),
                ),
                const SizedBox(height: 12),
                Text('${movie.year}', style: _MovieStyles.year),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HeaderIconButton(onTap: onBack, icon: const _BackIcon()),
                    _HeaderIconButton(
                      onTap: onBookmark,
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: 29,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.onTap, required this.icon});

  final VoidCallback onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(width: 48, height: 48, child: Center(child: icon)),
    );
  }
}

class _BackIcon extends StatelessWidget {
  const _BackIcon();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(size: Size(17, 29), painter: _BackIconPainter());
  }
}

class _BackIconPainter extends CustomPainter {
  const _BackIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.whiteColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width - 2, 2)
      ..lineTo(2, size.height / 2)
      ..lineTo(size.width - 2, size.height - 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PlayButtonPainter extends CustomPainter {
  const _PlayButtonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerRadius = size.width / 2;

    canvas.drawCircle(
      center,
      outerRadius,
      Paint()..color = AppColors.primaryColor,
    );

    canvas.drawCircle(
      center,
      outerRadius * 38.5 / 48.5,
      Paint()
        ..color = AppColors.whiteColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 10 / 97,
    );

    final triangle = Path()
      ..moveTo(size.width * 0.392, size.height * 0.346)
      ..lineTo(size.width * 0.392, size.height * 0.643)
      ..lineTo(size.width * 0.660, size.height * 0.5)
      ..close();

    canvas.drawPath(triangle, Paint()..color = AppColors.whiteColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WatchButton extends StatelessWidget {
  const _WatchButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: SizedBox(
        height: _watchButtonHeight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _watchRed,
            foregroundColor: AppColors.whiteColor,
            elevation: 0,
            padding: EdgeInsets.zero,
            minimumSize: const Size.fromHeight(_watchButtonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text('Watch', style: _MovieStyles.watch),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.movie});

  final MovieDetailsModel movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.favorite,
              iconSize: 28,
              value: '${movie.likes}',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              icon: Icons.access_time_filled,
              iconSize: 28,
              value: '${movie.runtimeMinutes}',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              icon: Icons.star,
              iconSize: 30,
              value: movie.rating.toStringAsFixed(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconSize,
    required this.value,
  });

  final IconData icon;
  final double iconSize;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _statsHeight,
      decoration: BoxDecoration(
        color: AppColors.darkFieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primaryColor, size: iconSize),
            const SizedBox(width: 16),
            Text(value, style: _MovieStyles.stats),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: Text(title, style: _MovieStyles.sectionTitle),
    );
  }
}

class _Screenshots extends StatelessWidget {
  const _Screenshots({required this.assets});

  final List<String> assets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: Column(
        children: [
          for (var index = 0; index < assets.length; index++) ...[
            if (index > 0) const SizedBox(height: 14),
            AspectRatio(
              aspectRatio: 398 / 166,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(assets[index], fit: BoxFit.cover),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SimilarGrid extends StatelessWidget {
  const _SimilarGrid({required this.movies});

  final List<SimilarMovie> movies;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 16,
          childAspectRatio: 189 / 279,
        ),
        itemBuilder: (context, index) => _SimilarCard(movie: movies[index]),
      ),
    );
  }
}

class _SimilarCard extends StatelessWidget {
  const _SimilarCard({required this.movie});

  final SimilarMovie movie;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(movie.posterAsset, fit: BoxFit.cover),
          Positioned(
            top: 13,
            left: 10,
            child: _RatingBadge(rating: movie.rating),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _ratingBadgeColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rating.toStringAsFixed(1), style: _MovieStyles.rating),
          const SizedBox(width: 6),
          Image.asset(AppAssets.movieDetailsRatingStar, width: 15, height: 15),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: Text(summary, style: _MovieStyles.summary),
    );
  }
}

class _CastList extends StatelessWidget {
  const _CastList({required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: Column(
        children: [
          for (var index = 0; index < cast.length; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            _CastCard(member: cast[index]),
          ],
        ],
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  const _CastCard({required this.member});

  final CastMember member;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 92),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.darkFieldColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              member.imageAsset,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name : ${member.name}', style: _MovieStyles.cast),
                const SizedBox(height: 2),
                Text(
                  'Character : ${member.character}',
                  style: _MovieStyles.cast,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Genres extends StatelessWidget {
  const _Genres({required this.genres});

  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _horizontal,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width >= 340
              ? 3
              : width >= 220
              ? 2
              : 1;
          final chipWidth = (width - (columns - 1) * 16) / columns;

          return Wrap(
            spacing: 16,
            runSpacing: 11,
            children: [
              for (final genre in genres)
                SizedBox(
                  width: chipWidth,
                  height: 36,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.darkFieldColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(genre, style: _MovieStyles.genre),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Typography taken from the Figma frame.
class _MovieStyles {
  const _MovieStyles._();

  static final TextStyle title = GoogleFonts.elMessiri(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.375,
    color: AppColors.whiteColor,
  );

  static final TextStyle year = GoogleFonts.elMessiri(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: _yearColor,
  );

  static final TextStyle sectionTitle = GoogleFonts.elMessiri(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: AppColors.whiteColor,
  );

  static final TextStyle watch = GoogleFonts.elMessiri(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.whiteColor,
  );

  static final TextStyle stats = GoogleFonts.elMessiri(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.whiteColor,
  );

  static final TextStyle rating = GoogleFonts.elMessiri(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.whiteColor,
  );

  static final TextStyle summary = GoogleFonts.elMessiri(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.375,
    color: AppColors.whiteColor,
  );

  static final TextStyle cast = GoogleFonts.elMessiri(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.375,
    color: AppColors.whiteColor,
  );

  static final TextStyle genre = GoogleFonts.elMessiri(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.375,
    color: AppColors.whiteColor,
  );
}
