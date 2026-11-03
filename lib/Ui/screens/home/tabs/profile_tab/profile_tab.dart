import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/Ui/widgets/auth/auth_failure.dart';
import 'package:movies_app/cubit/auth_cubit/auth_cubit.dart';
import 'package:movies_app/cubit/watch_list/saved_movie.dart';
import 'package:movies_app/cubit/watch_list/history_cubit.dart';
import 'package:movies_app/cubit/watch_list/watch_list_cubit.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  static final _headerColor = Color(0xFF212121);
  static final _popcornImage = 'assets/images/popcorn.png';

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkFieldColor,
        title: Text(l10n.authLogout),
        content: Text(l10n.authLogoutConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.authCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.authLogout),
          ),
        ],
      ),
    );
    if (shouldLogout != true) return;
    try {
      await authCubit.signOut();
    } on AuthFailure {
      messenger.showSnackBar(SnackBar(content: Text(l10n.authErrorUnexpected)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<AuthCubit>().state.user;
    final name = user?.displayName?.trim() ?? '';
    final photoUrl = user?.photoUrl;

    final watchList = context.watch<WatchListCubit>().state;
    final history = context.watch<HistoryCubit>().state;

    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Container(
              color: _headerColor,
              padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 130,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 58,
                              backgroundColor: AppColors.fieldColor,
                              backgroundImage: photoUrl == null
                                  ? null
                                  : AssetImage(photoUrl),
                              child: photoUrl == null
                                  ? Icon(
                                      Icons.person_outline,
                                      size: 58,
                                      color: AppColors.primaryColor,
                                    )
                                  : null,
                            ),
                            SizedBox(height: 12),
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          count: watchList.count,
                          label: l10n.profileWishList,
                        ),
                      ),
                      Expanded(
                        child: _Stat(
                          count: history.count,
                          label: l10n.profileHistory,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _ProfileButton(
                          label: l10n.authEditProfile,
                          color: AppColors.primaryColor,
                          textColor: AppColors.blackColor,
                          onPressed: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.updateProfileRouteName),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: _ProfileButton(
                          label: l10n.profileExit,
                          icon: Icons.logout,
                          color: Color(0xFFE82626),
                          textColor: AppColors.whiteColor,
                          onPressed: () => _confirmLogout(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                indicatorColor: AppColors.primaryColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.whiteColor,
                unselectedLabelColor: AppColors.whiteColor,
                labelStyle: TextStyle(fontSize: 20),
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.format_list_bulleted,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                    text: l10n.profileWatchList,
                  ),
                  Tab(
                    icon: Icon(
                      Icons.folder,
                      color: AppColors.primaryColor,
                      size: 32,
                    ),
                    text: l10n.profileHistory,
                  ),
                ],
              ),
            ),
          ),
        ],
        body: ColoredBox(
          color: AppColors.backgroundColor,
          child: TabBarView(
            children: [
              _MovieGrid(movies: watchList.movies),
              _MovieGrid(movies: history.movies),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  _Stat({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileButton extends StatelessWidget {
  _ProfileButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 20)),
            if (icon != null) ...[SizedBox(width: 8), Icon(icon, size: 24)],
          ],
        ),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  _EmptyList();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        ProfileTab._popcornImage,
        width: 124,
        errorBuilder: (_, _, _) => Icon(
          Icons.local_movies_outlined,
          size: 96,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) =>
      ColoredBox(color: ProfileTab._headerColor, child: tabBar);

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}

class _MovieGrid extends StatelessWidget {
  _MovieGrid({required this.movies});

  final List<SavedMovie> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return _EmptyList();

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.detailsRouteName,
            arguments: movie.id,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      ColoredBox(color: AppColors.fieldColor),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.blackColor71,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${movie.rating}',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Image.asset(AppAssets.star, width: 14, height: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
