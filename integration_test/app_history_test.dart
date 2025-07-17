import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ufscartaz_flutter/data/database/app_database.dart';
import 'package:ufscartaz_flutter/data/models/movie.dart';
import 'package:ufscartaz_flutter/data/models/user.dart';
import 'package:ufscartaz_flutter/data/repositories/movie_repository.dart';
import 'package:ufscartaz_flutter/data/database/movie_history_dao.dart';
import 'package:ufscartaz_flutter/data/services/movie_api_service.dart';

class FakeMovieApiService implements MovieApiService {
  @override
  Future<MovieResponse> getPopularMovies(String apiKey, int page) async => throw UnimplementedError();
  @override
  Future<MovieResponse> getTopRatedMovies(String apiKey, int page) async => throw UnimplementedError();
  @override
  Future<MovieResponse> getNowPlayingMovies(String apiKey, int page) async => throw UnimplementedError();
  @override
  Future<MovieResponse> getUpcomingMovies(String apiKey, int page) async => throw UnimplementedError();
  @override
  Future<Movie> getMovieDetails(int movieId, String apiKey) async => throw UnimplementedError();
  @override
  Future<MovieResponse> searchMovies(String apiKey, String query, int page) async => throw UnimplementedError();
  @override
  Future<MovieResponse> getMoviesByGenre(String apiKey, int genreId, int page) async => throw UnimplementedError();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late MovieRepository movieRepository;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'app_database.db');
    await deleteDatabase(path);
    database = await $FloorAppDatabase.databaseBuilder(path).build();
    movieRepository = MovieRepository(database, FakeMovieApiService());
  });

  tearDown(() async {
    await database.close();
  });

  group('Movie History Integration Test on Device', () {
    const userId = 1;

    final movie1 = Movie(
      id: 101,
      title: 'Filme Aventura 1',
      originalTitle: 'Adventure Movie 1',
      overview: 'Uma grande aventura.',
      posterPath: '/poster1.jpg',
      backdropPath: '/backdrop1.jpg',
      releaseDate: '2023-01-01',
      voteAverage: 8.5,
      genreIds: [28, 12],
      adult: false,
      originalLanguage: 'en',
      popularity: 100.0,
      video: false,
      voteCount: 500,
    );

    final movie2 = Movie(
      id: 102,
      title: 'Filme Comédia 2',
      originalTitle: 'Comedy Movie 2',
      overview: 'Muitas risadas.',
      posterPath: '/poster2.jpg',
      backdropPath: '/backdrop2.jpg',
      releaseDate: '2023-02-01',
      voteAverage: 7.0,
      genreIds: [35],
      adult: false,
      originalLanguage: 'en',
      popularity: 90.0,
      video: false,
      voteCount: 300,
    );

    testWidgets('deve adicionar e recuperar o histórico do banco de dados do dispositivo', (WidgetTester tester) async {
      // --- ARRANGE (Preparar) ---
      final testUser = User(
        id: userId,
        name: 'Test User',
        email: 'test@example.com',
        passwordHash: 'fake-password-hash-for-testing',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await database.userDao.insertUser(testUser);

      // --- ACT (Agir) ---
      await movieRepository.addToHistory(userId, movie1);
      await Future.delayed(const Duration(milliseconds: 20));
      await movieRepository.addToHistory(userId, movie2);

      final history = await database.movieHistoryDao.getRecentHistoryByUserId(userId, 10);

      // --- ASSERT (Verificar) ---
      expect(history, isNotNull);
      expect(history.length, 2);
      expect(history[0].movieId, movie2.id);
      expect(history[1].movieId, movie1.id);
      expect(history[0].movieTitle, movie2.title);
      expect(history[1].movieTitle, movie1.title);
    });
  });
}