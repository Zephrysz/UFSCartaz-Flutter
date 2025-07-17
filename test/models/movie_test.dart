import 'package:flutter_test/flutter_test.dart';
import 'package:ufscartaz_flutter/data/models/movie.dart';

void main() {
  group('Movie Model Tests', () {
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

    test('should create Movie instance with all properties', () {
      expect(testMovie.id, 123);
      expect(testMovie.title, 'Test Movie');
      expect(testMovie.originalTitle, 'Test Movie Original');
      expect(testMovie.overview, 'This is a test movie overview.');
      expect(testMovie.posterPath, '/test-poster.jpg');
      expect(testMovie.backdropPath, '/test-backdrop.jpg');
      expect(testMovie.releaseDate, '2024-01-15');
      expect(testMovie.voteAverage, 8.5);
      expect(testMovie.voteCount, 1000);
      expect(testMovie.adult, false);
      expect(testMovie.genreIds, [28, 12, 16]);
      expect(testMovie.video, false);
      expect(testMovie.popularity, 100.5);
      expect(testMovie.originalLanguage, 'en');
    });

    test('should create Movie instance with null optional properties', () {
      final movieWithNulls = Movie(
        id: 456,
        title: 'Test Movie 2',
        originalTitle: 'Test Movie 2 Original',
        overview: 'Another test movie.',
        releaseDate: '2024-02-20',
        voteAverage: 7.0,
        voteCount: 500,
        adult: false,
        genreIds: [18],
        video: false,
        popularity: 50.0,
        originalLanguage: 'pt',
      );

      expect(movieWithNulls.posterPath, null);
      expect(movieWithNulls.backdropPath, null);
      expect(movieWithNulls.id, 456);
      expect(movieWithNulls.title, 'Test Movie 2');
    });

    test('should serialize to JSON correctly', () {
      final json = testMovie.toJson();

      expect(json['id'], 123);
      expect(json['title'], 'Test Movie');
      expect(json['original_title'], 'Test Movie Original');
      expect(json['overview'], 'This is a test movie overview.');
      expect(json['poster_path'], '/test-poster.jpg');
      expect(json['backdrop_path'], '/test-backdrop.jpg');
      expect(json['release_date'], '2024-01-15');
      expect(json['vote_average'], 8.5);
      expect(json['vote_count'], 1000);
      expect(json['adult'], false);
      expect(json['genre_ids'], [28, 12, 16]);
      expect(json['video'], false);
      expect(json['popularity'], 100.5);
      expect(json['original_language'], 'en');
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 123,
        'title': 'Test Movie',
        'original_title': 'Test Movie Original',
        'overview': 'This is a test movie overview.',
        'poster_path': '/test-poster.jpg',
        'backdrop_path': '/test-backdrop.jpg',
        'release_date': '2024-01-15',
        'vote_average': 8.5,
        'vote_count': 1000,
        'adult': false,
        'genre_ids': [28, 12, 16],
        'video': false,
        'popularity': 100.5,
        'original_language': 'en',
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 123);
      expect(movie.title, 'Test Movie');
      expect(movie.originalTitle, 'Test Movie Original');
      expect(movie.overview, 'This is a test movie overview.');
      expect(movie.posterPath, '/test-poster.jpg');
      expect(movie.backdropPath, '/test-backdrop.jpg');
      expect(movie.releaseDate, '2024-01-15');
      expect(movie.voteAverage, 8.5);
      expect(movie.voteCount, 1000);
      expect(movie.adult, false);
      expect(movie.genreIds, [28, 12, 16]);
      expect(movie.video, false);
      expect(movie.popularity, 100.5);
      expect(movie.originalLanguage, 'en');
    });

    test('should generate correct full poster URL', () {
      expect(testMovie.fullPosterUrl, 'https://image.tmdb.org/t/p/w500/test-poster.jpg');
    });

    test('should generate correct full backdrop URL', () {
      expect(testMovie.fullBackdropUrl, 'https://image.tmdb.org/t/p/w500/test-backdrop.jpg');
    });

    test('should return empty string for full poster URL when posterPath is null', () {
      final movieWithoutPoster = Movie(
        id: 789,
        title: 'No Poster Movie',
        originalTitle: 'No Poster Movie',
        overview: 'Movie without poster.',
        releaseDate: '2024-03-01',
        voteAverage: 6.0,
        voteCount: 200,
        adult: false,
        genreIds: [35],
        video: false,
        popularity: 25.0,
        originalLanguage: 'es',
      );

      expect(movieWithoutPoster.fullPosterUrl, '');
    });

    test('should return empty string for full backdrop URL when backdropPath is null', () {
      final movieWithoutBackdrop = Movie(
        id: 789,
        title: 'No Backdrop Movie',
        originalTitle: 'No Backdrop Movie',
        overview: 'Movie without backdrop.',
        releaseDate: '2024-03-01',
        voteAverage: 6.0,
        voteCount: 200,
        adult: false,
        genreIds: [35],
        video: false,
        popularity: 25.0,
        originalLanguage: 'es',
      );

      expect(movieWithoutBackdrop.fullBackdropUrl, '');
    });

    test('should format rating correctly', () {
      expect(testMovie.formattedRating, '8.5');
      
      final movieWithLowRating = Movie(
        id: 124,
        title: 'Low Rating Movie',
        originalTitle: 'Low Rating Movie',
        overview: 'Movie with low rating.',
        releaseDate: '2024-01-15',
        voteAverage: 7.23456,
        voteCount: 1000,
        adult: false,
        genreIds: [28, 12, 16],
        video: false,
        popularity: 100.5,
        originalLanguage: 'en',
      );
      expect(movieWithLowRating.formattedRating, '7.2');
    });

    test('should extract release year correctly', () {
      expect(testMovie.releaseYear, '2024');
      
      final movieWithShortDate = Movie(
        id: 125,
        title: 'Short Date Movie',
        originalTitle: 'Short Date Movie',
        overview: 'Movie with short date.',
        releaseDate: '2023',
        voteAverage: 8.5,
        voteCount: 1000,
        adult: false,
        genreIds: [28, 12, 16],
        video: false,
        popularity: 100.5,
        originalLanguage: 'en',
      );
      expect(movieWithShortDate.releaseYear, '2023');
    });

    test('should return empty string for release year when date is too short', () {
      final movieWithInvalidDate = Movie(
        id: 126,
        title: 'Invalid Date Movie',
        originalTitle: 'Invalid Date Movie',
        overview: 'Movie with invalid date.',
        releaseDate: '202',
        voteAverage: 8.5,
        voteCount: 1000,
        adult: false,
        genreIds: [28, 12, 16],
        video: false,
        popularity: 100.5,
        originalLanguage: 'en',
      );
      expect(movieWithInvalidDate.releaseYear, '');
    });

    test('should return empty string for release year when date is empty', () {
      final movieWithEmptyDate = Movie(
        id: 127,
        title: 'Empty Date Movie',
        originalTitle: 'Empty Date Movie',
        overview: 'Movie with empty date.',
        releaseDate: '',
        voteAverage: 8.5,
        voteCount: 1000,
        adult: false,
        genreIds: [28, 12, 16],
        video: false,
        popularity: 100.5,
        originalLanguage: 'en',
      );
      expect(movieWithEmptyDate.releaseYear, '');
    });

    test('should implement equality correctly', () {
      final sameMovie = Movie(
        id: 123,
        title: 'Different Title',
        originalTitle: 'Different Original Title',
        overview: 'Different overview.',
        releaseDate: '2023-01-01',
        voteAverage: 5.0,
        voteCount: 100,
        adult: true,
        genreIds: [10],
        video: true,
        popularity: 10.0,
        originalLanguage: 'fr',
      );

      final differentMovie = Movie(
        id: 456,
        title: 'Test Movie',
        originalTitle: 'Test Movie Original',
        overview: 'This is a test movie overview.',
        releaseDate: '2024-01-15',
        voteAverage: 8.5,
        voteCount: 1000,
        adult: false,
        genreIds: [28, 12, 16],
        video: false,
        popularity: 100.5,
        originalLanguage: 'en',
      );

      expect(testMovie == sameMovie, true);
      expect(testMovie == differentMovie, false);
      expect(testMovie.hashCode == sameMovie.hashCode, true);
      expect(testMovie.hashCode == differentMovie.hashCode, false);
    });

    test('should have correct string representation', () {
      final stringRepresentation = testMovie.toString();
      expect(stringRepresentation, 'Movie{id: 123, title: Test Movie, releaseDate: 2024-01-15}');
    });

    test('should handle null values in JSON serialization', () {
      final movieWithNulls = Movie(
        id: 999,
        title: 'Null Movie',
        originalTitle: 'Null Movie Original',
        overview: 'Movie with null values.',
        releaseDate: '2024-04-01',
        voteAverage: 5.5,
        voteCount: 50,
        adult: false,
        genreIds: [14],
        video: false,
        popularity: 15.0,
        originalLanguage: 'de',
      );

      final json = movieWithNulls.toJson();
      expect(json['poster_path'], null);
      expect(json['backdrop_path'], null);
      expect(json['id'], 999);
      expect(json['title'], 'Null Movie');
    });
  });
} 