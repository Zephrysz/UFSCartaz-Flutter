// movie_card_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ufscartaz_flutter/data/models/movie.dart';
import 'package:ufscartaz_flutter/presentation/widgets/movie_card.dart';

void main() {
  group('MovieCard Widget Tests', () {
    late Movie testMovie;

    setUp(() {
      testMovie = Movie(
        id: 123,
        title: 'Test Movie',
        originalTitle: 'Test Movie Original',
        overview: 'This is a test movie overview.',
        posterPath: '/test-poster.jpg',
        backdropPath: '/test-backdrop.jpg',
        releaseDate: '2024-01-15',
        voteAverage: 8.5,
        voteCount: 1000,
        adult: false,
        genreIds: [28, 12, 16],
        video: false,
        popularity: 100.5,
        originalLanguage: 'en',
      );
    });

    Widget createWidgetUnderTest({
      required Movie movie,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: MovieCard(
            movie: movie,
            onTap: onTap,
          ),
        ),
      );
    }

    testWidgets('should display movie information correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(movie: testMovie));

      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('8.5'), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      bool tapped = false;
      void onTap() {
        tapped = true;
      }

      await tester.pumpWidget(createWidgetUnderTest(
        movie: testMovie,
        onTap: onTap,
      ));

      await tester.tap(find.byType(MovieCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('should display rating with star icon', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(movie: testMovie));

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('8.5'), findsOneWidget);
    });

    testWidgets('should handle empty release date', (WidgetTester tester) async {
      final movieWithEmptyDate = Movie(
        id: 789,
        title: 'Empty Date Movie',
        originalTitle: 'Empty Date Movie',
        overview: 'Movie with empty date.',
        releaseDate: '', // Data vazia
        voteAverage: 7.0,
        voteCount: 300,
        adult: false,
        genreIds: [18],
        video: false,
        popularity: 30.0,
        originalLanguage: 'fr',
      );

      await tester.pumpWidget(createWidgetUnderTest(movie: movieWithEmptyDate));

      expect(find.text('Empty Date Movie'), findsOneWidget);
      expect(find.text('7.0'), findsOneWidget);
      // CORREÇÃO: Verifica que o separador '•' (e, por consequência, o ano) não é renderizado
      expect(find.text('•'), findsNothing);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(movie: testMovie));

    });

    testWidgets('should display correct poster URL', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(movie: testMovie));

      final cachedNetworkImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );

      expect(cachedNetworkImage.imageUrl, 'https://image.tmdb.org/t/p/w500/test-poster.jpg');
    });

    testWidgets('should handle low ratings', (WidgetTester tester) async {
      final lowRatingMovie = Movie(
        id: 999,
        title: 'Low Rating Movie',
        originalTitle: 'Low Rating Movie',
        overview: 'Movie with low rating.',
        releaseDate: '2024-05-01',
        voteAverage: 3.2,
        voteCount: 50,
        adult: false,
        genreIds: [27],
        video: false,
        popularity: 5.0,
        originalLanguage: 'de',
      );

      await tester.pumpWidget(createWidgetUnderTest(movie: lowRatingMovie));

      expect(find.text('Low Rating Movie'), findsOneWidget);
      expect(find.text('3.2'), findsOneWidget);
    });

    testWidgets('should handle high ratings', (WidgetTester tester) async {
      final highRatingMovie = Movie(
        id: 1000,
        title: 'High Rating Movie',
        originalTitle: 'High Rating Movie',
        overview: 'Movie with high rating.',
        releaseDate: '2024-06-01',
        voteAverage: 9.8,
        voteCount: 5000,
        adult: false,
        genreIds: [18, 10749],
        video: false,
        popularity: 200.0,
        originalLanguage: 'en',
      );

      await tester.pumpWidget(createWidgetUnderTest(movie: highRatingMovie));

      expect(find.text('High Rating Movie'), findsOneWidget);
      expect(find.text('9.8'), findsOneWidget);
    });
  });
}