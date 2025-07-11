import '../database/app_database.dart';
import '../models/movie.dart';
import '../models/movie_history_entry.dart';
import '../services/movie_api_service.dart';
import '../../core/constants/app_constants.dart';

class MovieRepository {
  final AppDatabase _database;
  final MovieApiService _apiService;

  MovieRepository(this._database, this._apiService);

  // API-based movie fetching
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _apiService.getPopularMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      // Cache movies locally
      await _database.movieDao.insertMovies(response.results);
      
      return response.results;
    } catch (e) {
      // Fallback to local data if API fails
      return await _database.movieDao.getPopularMovies(20);
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _apiService.getTopRatedMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      await _database.movieDao.insertMovies(response.results);
      
      return response.results;
    } catch (e) {
      return await _database.movieDao.getTopRatedMovies(20);
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _apiService.getNowPlayingMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      await _database.movieDao.insertMovies(response.results);
      
      return response.results;
    } catch (e) {
      return await _database.movieDao.getAllMovies();
    }
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _apiService.getUpcomingMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      await _database.movieDao.insertMovies(response.results);
      
      return response.results;
    } catch (e) {
      return await _database.movieDao.getAllMovies();
    }
  }

  Future<Movie?> getMovieDetails(int movieId) async {
    try {
      final movie = await _apiService.getMovieDetails(
        movieId,
        AppConstants.tmdbApiKey,
      );
      
      await _database.movieDao.insertMovie(movie);
      
      return movie;
    } catch (e) {
      return await _database.movieDao.getMovieById(movieId);
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _apiService.searchMovies(
        AppConstants.tmdbApiKey,
        query,
        page,
      );
      
      await _database.movieDao.insertMovies(response.results);
      
      return response.results;
    } catch (e) {
      // Fallback to local search
      return await _database.movieDao.searchMovies('%$query%');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _apiService.getMoviesByGenre(
        AppConstants.tmdbApiKey,
        genreId,
        page,
      );
      
      await _database.movieDao.insertMovies(response.results);
      
      return response.results;
    } catch (e) {
      return await _database.movieDao.getAllMovies();
    }
  }

  // Local database methods
  Future<List<Movie>> getAllMovies() async {
    return await _database.movieDao.getAllMovies();
  }

  Future<List<Movie>> getLocalPopularMovies() async {
    return await _database.movieDao.getPopularMovies(20);
  }

  Future<List<Movie>> getLocalTopRatedMovies() async {
    return await _database.movieDao.getTopRatedMovies(20);
  }

  Future<List<Movie>> searchLocalMovies(String query) async {
    return await _database.movieDao.searchMovies('%$query%');
  }

  // Movie History methods
  Future<void> addToHistory(int userId, Movie movie) async {
    final historyEntry = MovieHistoryEntry(
      userId: userId,
      movieId: movie.id,
      movieTitle: movie.title,
      moviePosterPath: movie.posterPath,
      viewedAt: DateTime.now(),
    );

    await _database.movieHistoryDao.insertHistoryEntry(historyEntry);
  }

  Future<List<MovieHistoryEntry>> getUserHistory(int userId) async {
    return await _database.movieHistoryDao.getHistoryByUserId(userId);
  }

  Future<List<MovieHistoryEntry>> getRecentHistory(int userId, {int limit = 10}) async {
    return await _database.movieHistoryDao.getRecentHistoryByUserId(userId, limit);
  }

  Future<void> removeFromHistory(int userId, int movieId) async {
    await _database.movieHistoryDao.deleteHistoryEntryByUserAndMovie(userId, movieId);
  }

  Future<void> clearUserHistory(int userId) async {
    await _database.movieHistoryDao.deleteHistoryByUserId(userId);
  }

  // Utility methods
  Future<void> refreshMovieCache() async {
    try {
      final popularMovies = await _apiService.getPopularMovies(AppConstants.tmdbApiKey, 1);
      final topRatedMovies = await _apiService.getTopRatedMovies(AppConstants.tmdbApiKey, 1);
      
      await _database.movieDao.deleteAllMovies();
      await _database.movieDao.insertMovies(popularMovies.results);
      await _database.movieDao.insertMovies(topRatedMovies.results);
    } catch (e) {
      // Ignore cache refresh errors
    }
  }
} 