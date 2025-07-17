import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/models/movie_history_entry.dart';
import '../../data/repositories/movie_repository.dart';
import '../../core/constants/app_constants.dart'; // Importe suas constantes

class MovieProvider extends ChangeNotifier {
  final MovieRepository _movieRepository;

  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _actionMovies = [];
  List<Movie> _comedyMovies = [];

  List<Movie> _searchResults = [];
  List<MovieHistoryEntry> _recentHistory = [];
  Movie? _selectedMovie;

  bool _isLoading = false;
  bool _isLoadingDetails = false;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  MovieProvider(this._movieRepository) {
    // _loadInitialData já é chamado aqui, o que é ótimo.
    _loadInitialData();
  }

  // Getters
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get searchResults => _searchResults;
  List<MovieHistoryEntry> get recentHistory => _recentHistory;
  Movie? get selectedMovie => _selectedMovie;

  // --- ADICIONADO ---
  List<Movie> get actionMovies => _actionMovies;
  List<Movie> get comedyMovies => _comedyMovies;
  // --------------------

  bool get isLoading => _isLoading;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> _loadInitialData() async {
    _setLoading(true);
    _error = null;

    try {
      print('MovieProvider: Starting to load initial data...');
      
      // Load movies in parallel
      await Future.wait([
        loadPopularMovies(),
        loadTopRatedMovies(),
        loadNowPlayingMovies(),
        loadMoviesByGenre(AppConstants.movieGenres['action']!, 'action'),
        loadMoviesByGenre(AppConstants.movieGenres['comedy']!, 'comedy'),
      ]);
      
      print('MovieProvider: Successfully loaded initial data');
      print('Popular movies: ${_popularMovies.length}');
      print('Top rated movies: ${_topRatedMovies.length}');
      print('Action movies: ${_actionMovies.length}');
      print('Comedy movies: ${_comedyMovies.length}');
      
    } catch (e) {
      print('MovieProvider: Error loading initial data: $e');
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Load popular movies
  Future<void> loadPopularMovies() async {
    try {
      print('MovieProvider: Loading popular movies...');
      final movies = await _movieRepository.getPopularMovies();
      print('MovieProvider: Repository returned ${movies.length} popular movies');
      
      if (movies.isNotEmpty) {
        print('MovieProvider: First popular movie: ${movies.first.title}');
      }
      
      _popularMovies = movies;
      print('MovieProvider: Set _popularMovies to ${_popularMovies.length} movies');
      notifyListeners();
    } catch (e) {
      print('MovieProvider: Error loading popular movies: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load top rated movies
  Future<void> loadTopRatedMovies() async {
    try {
      print('MovieProvider: Loading top rated movies...');
      final movies = await _movieRepository.getTopRatedMovies();
      print('MovieProvider: Repository returned ${movies.length} top rated movies');
      
      if (movies.isNotEmpty) {
        print('MovieProvider: First top rated movie: ${movies.first.title}');
      }
      
      _topRatedMovies = movies;
      print('MovieProvider: Set _topRatedMovies to ${_topRatedMovies.length} movies');
      notifyListeners();
    } catch (e) {
      print('MovieProvider: Error loading top rated movies: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load now playing movies
  Future<void> loadNowPlayingMovies() async {
    try {
      print('MovieProvider: Loading now playing movies...');
      final movies = await _movieRepository.getNowPlayingMovies();
      print('MovieProvider: Repository returned ${movies.length} now playing movies');
      
      if (movies.isNotEmpty) {
        print('MovieProvider: First now playing movie: ${movies.first.title}');
      }
      
      _nowPlayingMovies = movies;
      print('MovieProvider: Set _nowPlayingMovies to ${_nowPlayingMovies.length} movies');
      notifyListeners();
    } catch (e) {
      print('MovieProvider: Error loading now playing movies: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load upcoming movies
  Future<void> loadUpcomingMovies() async {
    try {
      print('MovieProvider: Loading upcoming movies...');
      _upcomingMovies = await _movieRepository.getUpcomingMovies();
      print('MovieProvider: Loaded ${_upcomingMovies.length} upcoming movies');
      notifyListeners();
    } catch (e) {
      print('MovieProvider: Error loading upcoming movies: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load movies by genre
  Future<void> loadMoviesByGenre(int genreId, String category) async {
    try {
      print('MovieProvider: Loading $category movies (genre: $genreId)...');
      final movies = await _movieRepository.getMoviesByGenre(genreId);
      print('MovieProvider: Repository returned ${movies.length} $category movies');
      
      if (movies.isNotEmpty) {
        print('MovieProvider: First $category movie: ${movies.first.title}');
      }
      
      if (category == 'action') {
        _actionMovies = movies;
        print('MovieProvider: Set _actionMovies to ${_actionMovies.length} movies');
      } else if (category == 'comedy') {
        _comedyMovies = movies;
        print('MovieProvider: Set _comedyMovies to ${_comedyMovies.length} movies');
      }
      notifyListeners();
    } catch (e) {
      print('MovieProvider: Error loading $category movies: $e');
      _error = e.toString();
      notifyListeners();
    }
  }

  // --- REMOVIDO ---
  // O método antigo é removido para evitar o anti-padrão de chamá-lo no FutureBuilder.
  /*
  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    try {
      return await _movieRepository.getMoviesByGenre(genreId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }
  */
  // -----------------

  // Search movies
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _setSearching(true);
    _searchQuery = query;

    try {
      _searchResults = await _movieRepository.searchMovies(query);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setSearching(false);
    }
  }

  // Get movie details
  Future<void> getMovieDetails(int movieId) async {
    _setLoadingDetails(true);

    try {
      _selectedMovie = await _movieRepository.getMovieDetails(movieId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoadingDetails(false);
    }
  }

  // Load user's recent history
  Future<void> loadRecentHistory(int userId) async {
    try {
      _recentHistory = await _movieRepository.getRecentHistory(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add movie to history
  Future<void> addToHistory(int userId, Movie movie) async {
    try {
      await _movieRepository.addToHistory(userId, movie);
      await loadRecentHistory(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear search results
  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }

  // Clear selected movie
  void clearSelectedMovie() {
    _selectedMovie = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refresh() async {
    await _loadInitialData();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingDetails(bool loading) {
    _isLoadingDetails = loading;
    notifyListeners();
  }

  void _setSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }
}