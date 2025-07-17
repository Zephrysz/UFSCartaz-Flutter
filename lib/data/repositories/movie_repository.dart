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
      print('MovieRepository: Fetching popular movies from API...');
      final response = await _apiService.getPopularMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      print('MovieRepository: API returned ${response.results.length} popular movies');
      
      // Try to cache movies locally, but don't fail if database has issues
      try {
        await _database.movieDao.insertMovies(response.results);
        print('MovieRepository: Successfully cached popular movies');
      } catch (dbError) {
        print('MovieRepository: Database cache failed (ignoring): $dbError');
      }
      
      print('MovieRepository: Returning ${response.results.length} popular movies to provider');
      return response.results;
    } catch (e) {
      print('MovieRepository: API call failed: $e');
      // Fallback to local data if API fails
      try {
        final localMovies = await _database.movieDao.getPopularMovies(20);
        print('MovieRepository: Database fallback returned ${localMovies.length} movies');
        return localMovies;
      } catch (dbError) {
        print('MovieRepository: Database fallback failed: $dbError');
        return []; // Return empty list if both API and database fail
      }
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      print('MovieRepository: Fetching top rated movies from API...');
      final response = await _apiService.getTopRatedMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      print('MovieRepository: API returned ${response.results.length} top rated movies');
      
      // Try to cache movies locally, but don't fail if database has issues
      try {
        await _database.movieDao.insertMovies(response.results);
        print('MovieRepository: Successfully cached top rated movies');
      } catch (dbError) {
        print('MovieRepository: Database cache failed (ignoring): $dbError');
      }
      
      return response.results;
    } catch (e) {
      print('MovieRepository: API call failed: $e');
      try {
        return await _database.movieDao.getTopRatedMovies(20);
      } catch (dbError) {
        print('MovieRepository: Database fallback failed: $dbError');
        return []; // Return empty list if both API and database fail
      }
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      print('MovieRepository: Fetching now playing movies from API...');
      final response = await _apiService.getNowPlayingMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      print('MovieRepository: API returned ${response.results.length} now playing movies');
      
      // Try to cache movies locally, but don't fail if database has issues
      try {
        await _database.movieDao.insertMovies(response.results);
        print('MovieRepository: Successfully cached now playing movies');
      } catch (dbError) {
        print('MovieRepository: Database cache failed (ignoring): $dbError');
      }
      
      return response.results;
    } catch (e) {
      print('MovieRepository: API call failed: $e');
      try {
        return await _database.movieDao.getAllMovies();
      } catch (dbError) {
        print('MovieRepository: Database fallback failed: $dbError');
        return []; // Return empty list if both API and database fail
      }
    }
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1}) async {
    try {
      print('MovieRepository: Fetching upcoming movies from API...');
      final response = await _apiService.getUpcomingMovies(
        AppConstants.tmdbApiKey,
        page,
      );
      
      print('MovieRepository: API returned ${response.results.length} upcoming movies');
      
      // Try to cache movies locally, but don't fail if database has issues
      try {
        await _database.movieDao.insertMovies(response.results);
        print('MovieRepository: Successfully cached upcoming movies');
      } catch (dbError) {
        print('MovieRepository: Database cache failed (ignoring): $dbError');
      }
      
      return response.results;
    } catch (e) {
      print('MovieRepository: API call failed: $e');
      try {
        return await _database.movieDao.getAllMovies();
      } catch (dbError) {
        print('MovieRepository: Database fallback failed: $dbError');
        return []; // Return empty list if both API and database fail
      }
    }
  }

  Future<Movie?> getMovieDetails(int movieId) async {
    try {
      print('MovieRepository: Fetching movie details for ID $movieId from API...');
      final movie = await _apiService.getMovieDetails(
        movieId,
        AppConstants.tmdbApiKey,
      );
      
      print('MovieRepository: API returned movie details: ${movie.title}');
      
      // Try to cache movie locally, but don't fail if database has issues
      try {
        await _database.movieDao.insertMovie(movie);
        print('MovieRepository: Successfully cached movie details');
      } catch (dbError) {
        print('MovieRepository: Database cache failed (ignoring): $dbError');
      }
      
      return movie;
    } catch (e) {
      print('MovieRepository: API call failed: $e');
      try {
        return await _database.movieDao.getMovieById(movieId);
      } catch (dbError) {
        print('MovieRepository: Database fallback failed: $dbError');
        return null; // Return null if both API and database fail
      }
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      print('MovieRepository: Searching movies for "$query" from API...');
      final response = await _apiService.searchMovies(
        AppConstants.tmdbApiKey,
        query,
        page,
      );
      
      print('MovieRepository: API returned ${response.results.length} search results');
      
      // Try to cache movies locally, but don't fail if database has issues
      try {
        await _database.movieDao.insertMovies(response.results);
        print('MovieRepository: Successfully cached search results');
      } catch (dbError) {
        print('MovieRepository: Database cache failed (ignoring): $dbError');
      }
      
      return response.results;
    } catch (e) {
      print('MovieRepository: API call failed: $e');
      // Fallback to local search
      try {
        return await _database.movieDao.searchMovies('%$query%');
      } catch (dbError) {
        print('MovieRepository: Database fallback failed: $dbError');
        return []; // Return empty list if both API and database fail
      }
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      print('MovieRepository: Fetching movies by genre $genreId from API...');
      final response = await _apiService.getMoviesByGenre(
        AppConstants.tmdbApiKey,
        genreId,
        page,
      );
      
      print('MovieRepository: API returned ${response.results.length} movies for genre $genreId');
      
      // Try to cache movies locally, but don't fail if database has issues
      try {
        await _database.movieDao.insertMovies(response.results);
        print('MovieRepository: Successfully cached genre movies');
      } catch (dbError) {
        print('MovieRepository: Database cache failed (ignoring): $dbError');
      }
      
      return response.results;
    } catch (e) {
      print('MovieRepository: API call failed: $e');
      try {
        return await _database.movieDao.getAllMovies();
      } catch (dbError) {
        print('MovieRepository: Database fallback failed: $dbError');
        return []; // Return empty list if both API and database fail
      }
    }
  }

  // Local database methods
  Future<List<Movie>> getAllMovies() async {
    try {
      return await _database.movieDao.getAllMovies();
    } catch (e) {
      print('MovieRepository: getAllMovies failed: $e');
      return [];
    }
  }

  Future<List<Movie>> getLocalPopularMovies() async {
    try {
      return await _database.movieDao.getPopularMovies(20);
    } catch (e) {
      print('MovieRepository: getLocalPopularMovies failed: $e');
      return [];
    }
  }

  Future<List<Movie>> getLocalTopRatedMovies() async {
    try {
      return await _database.movieDao.getTopRatedMovies(20);
    } catch (e) {
      print('MovieRepository: getLocalTopRatedMovies failed: $e');
      return [];
    }
  }

  Future<List<Movie>> searchLocalMovies(String query) async {
    try {
      return await _database.movieDao.searchMovies('%$query%');
    } catch (e) {
      print('MovieRepository: searchLocalMovies failed: $e');
      return [];
    }
  }

  // Movie History methods
  Future<void> addToHistory(int userId, Movie movie) async {
    try {
      // Verificar se já existe uma entrada para este usuário e filme
      final existingEntry = await _database.movieHistoryDao.getHistoryEntryByUserAndMovie(userId, movie.id);
      
      if (existingEntry != null) {
        // Se já existe, atualizar a data de visualização
        final updatedEntry = MovieHistoryEntry(
          id: existingEntry.id,
          userId: userId,
          movieId: movie.id,
          movieTitle: movie.title,
          moviePosterPath: movie.posterPath,
          viewedAt: DateTime.now(),
        );
        await _database.movieHistoryDao.updateHistoryEntry(updatedEntry);
      } else {
        // Se não existe, criar nova entrada
        final historyEntry = MovieHistoryEntry(
          userId: userId,
          movieId: movie.id,
          movieTitle: movie.title,
          moviePosterPath: movie.posterPath,
          viewedAt: DateTime.now(),
        );
        await _database.movieHistoryDao.insertHistoryEntry(historyEntry);
      }
    } catch (e) {
      print('MovieRepository: addToHistory failed: $e');
    }
  }

  Future<List<MovieHistoryEntry>> getUserHistory(int userId) async {
    try {
      return await _database.movieHistoryDao.getHistoryByUserId(userId);
    } catch (e) {
      print('MovieRepository: getUserHistory failed: $e');
      return [];
    }
  }

  Future<List<MovieHistoryEntry>> getRecentHistory(int userId, {int limit = 10}) async {
    try {
      return await _database.movieHistoryDao.getRecentHistoryByUserId(userId, limit);
    } catch (e) {
      print('MovieRepository: getRecentHistory failed: $e');
      return [];
    }
  }

  Future<void> removeFromHistory(int userId, int movieId) async {
    try {
      await _database.movieHistoryDao.deleteHistoryEntryByUserAndMovie(userId, movieId);
    } catch (e) {
      print('MovieRepository: removeFromHistory failed: $e');
    }
  }

  Future<void> clearUserHistory(int userId) async {
    try {
      await _database.movieHistoryDao.deleteHistoryByUserId(userId);
    } catch (e) {
      print('MovieRepository: clearUserHistory failed: $e');
    }
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
      print('MovieRepository: refreshMovieCache failed: $e');
    }
  }
} 