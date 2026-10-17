import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../cubit/home/featured_carousel_cubit.dart';
import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/size_utils.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  static const _featuredMovies = [
    AppAssets.posterSideLeft,
    AppAssets.hero1917,
    AppAssets.posterSideRight,
    AppAssets.posterAction1,
    AppAssets.posterAction2,
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: .6);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;

    return BlocProvider(
      create: (_) => FeaturedCarouselCubit(),
      child: BlocBuilder<FeaturedCarouselCubit, int>(
        builder: (context, activeMovieIndex) {
          final activeMovie = _featuredMovies[activeMovieIndex];

          return Container(
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: height * .09),
              child: Stack(
                children: [
                  Container(
                    height: height * .692,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(activeMovie),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: height * .692,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xCC121312),
                          Color(0x99121312),
                          AppColors.backgroundColor,
                        ],
                        stops: [0, .465, 1],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * .008),
                      Center(
                        child: Image.asset(
                          AppAssets.availableNow,
                          width: width * .62,
                          height: height * .1,
                        ),
                      ),
                      SizedBox(height: height * .02),
                      SizedBox(
                        height: height * .4,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _featuredMovies.length,
                          onPageChanged: context
                              .read<FeaturedCarouselCubit>()
                              .selectMovie,
                          itemBuilder: (context, index) => Center(
                            child: _FeaturedMovie(
                              image: _featuredMovies[index],
                              rating: '7.7',
                              isActive: index == activeMovieIndex,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .01),
                      Center(
                        child: Image.asset(
                          AppAssets.watchNow,
                          width: width * .82,
                          height: height * .157,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          width * .037,
                          height * .025,
                          width * .065,
                          height * .015,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Action',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * .047,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'See More',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: width * .037,
                              ),
                            ),
                            SizedBox(width: width * .015),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.primaryColor,
                              size: width * .018,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * .25,
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * .037,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          separatorBuilder: (_, _) =>
                              SizedBox(width: width * .037),
                          itemBuilder: (context, index) => _ActionMovieCard(
                            image: [
                              AppAssets.posterSideRight,
                              AppAssets.posterAction1,
                              AppAssets.posterAction2,
                              AppAssets.posterSideLeft,
                            ][index],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedMovie extends StatelessWidget {
  const _FeaturedMovie({
    required this.image,
    required this.rating,
    required this.isActive,
  });

  final String image;
  final String rating;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final height = context.height;
    final cardWidth = width * (isActive ? .544 : .428);
    final cardHeight = height * (isActive ? .377 : .297);

    return SizedBox(
      width: width * .6,
      height: height * .4,
      child: Center(
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width * .047),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(image, fit: BoxFit.cover),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(width * .03),
                    child: _Rating(rating: rating, width: width),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionMovieCard extends StatelessWidget {
  const _ActionMovieCard({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    final width = context.width;

    return SizedBox(
      width: width * .34,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(width * .047),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(width * .03),
                child: _Rating(rating: '7.7', width: width),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating, required this.width});

  final String rating;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * .135,
      height: width * .065,
      padding: EdgeInsets.symmetric(horizontal: width * .014),
      decoration: BoxDecoration(
        color: const Color(0xB5121312),
        borderRadius: BorderRadius.circular(width * .023),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            rating,
            style: TextStyle(color: Colors.white, fontSize: width * .037),
          ),
          SizedBox(width: width * .009),
          Image.asset(
            AppAssets.star,
            width: width * .035,
            height: width * .035,
          ),
        ],
      ),
    );
  }
}
