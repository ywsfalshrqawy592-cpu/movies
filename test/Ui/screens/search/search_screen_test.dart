import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/Ui/screens/movie_details/movie_details_screen.dart';
import 'package:movies_app/Ui/screens/search/search_screen.dart';

Future<void> pumpSearch(
  WidgetTester tester, {
  Size size = const Size(430, 932),
  SearchMovies? search,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(search: search),
    ),
  );
  await tester.pump();
}

Future<void> enterQuery(WidgetTester tester, String query) async {
  await tester.enterText(find.byKey(const Key('searchField')), query);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('starts on the empty state with the designed geometry', (
    tester,
  ) async {
    await pumpSearch(tester);

    expect(find.byKey(const Key('searchEmptyState')), findsOneWidget);
    expect(find.byKey(const Key('searchResultsGrid')), findsNothing);
    expect(find.text('Search'), findsOneWidget);

    final field = tester.getRect(find.byKey(const Key('searchField')));
    final nav = tester.getRect(find.byKey(const Key('searchBottomNav')));

    expect(field.left, closeTo(16, 0.01));
    expect(field.top, closeTo(21, 0.01));
    expect(field.width, closeTo(398, 0.01));
    expect(field.height, closeTo(56, 0.01));
    expect(nav.left, closeTo(9, 0.01));
    expect(nav.top, closeTo(862, 0.01));
    expect(nav.width, closeTo(413, 0.01));
    expect(nav.height, closeTo(56, 0.01));
  });

  testWidgets('searches the local catalog and shows the result grid', (
    tester,
  ) async {
    await pumpSearch(tester);

    await enterQuery(tester, 'Marvel');

    expect(find.byKey(const Key('searchResultsGrid')), findsOneWidget);
    expect(find.byKey(const Key('searchLoading')), findsNothing);
    expect(
      find.byKey(const ValueKey('searchMovie_Black Widow')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('searchMovie_Joker')), findsOneWidget);

    final card = tester.getRect(
      find.byKey(const ValueKey('searchMovie_Black Widow')),
    );
    expect(card.left, closeTo(16, 0.01));
    expect(card.top, closeTo(89, 0.01));
    expect(card.width, closeTo(191, 0.01));
    expect(card.height, closeTo(279, 0.01));

    final nav = tester.getRect(find.byKey(const Key('searchBottomNav')));
    expect(nav.top, closeTo(862, 0.01));
    expect(nav.height, closeTo(61, 0.01));
  });

  testWidgets('keeps the grid proportional on a narrow screen', (tester) async {
    await pumpSearch(tester, size: const Size(320, 932));
    await enterQuery(tester, 'Marvel');

    final card = tester.getRect(
      find.byKey(const ValueKey('searchMovie_Black Widow')),
    );
    expect(card.left, closeTo(16, 0.01));
    expect(card.top, closeTo(89, 0.01));
    expect(card.width, closeTo(136, 0.01));
    expect(card.height, closeTo(198.7, 0.1));
  });

  testWidgets('shows no results and returns to the empty state when cleared', (
    tester,
  ) async {
    await pumpSearch(tester);

    await enterQuery(tester, 'zzzz');
    expect(find.byKey(const Key('searchNoResults')), findsOneWidget);

    await enterQuery(tester, '');
    expect(find.byKey(const Key('searchEmptyState')), findsOneWidget);
  });

  testWidgets('shows an error state when the search source fails', (
    tester,
  ) async {
    await pumpSearch(tester, search: (_) async => throw Exception('offline'));

    await enterQuery(tester, 'Marvel');

    expect(find.byKey(const Key('searchError')), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('opens movie details from a result card', (tester) async {
    await pumpSearch(tester);
    await enterQuery(tester, 'Marvel');

    await tester.tap(find.byKey(const ValueKey('searchMovie_Black Widow')));
    await tester.pumpAndSettle();

    expect(find.byType(MovieDetailsScreen), findsOneWidget);
  });
}
