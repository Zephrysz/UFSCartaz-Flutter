import 'package:flutter/material.dart';
import '../../data/models/movie.dart';
import '../../data/models/movie_history_entry.dart';
import '../../data/repositories/movie_repository.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepository _movieRepository;
  
  List<Movie> _popularMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _searchResults = [];
  List<MovieHistoryEntry> _recentHistory = [];
  Movie? _selectedMovie;
  
  bool _isLoading = false;
  bool _isLoadingDetails = false;
  bool _isSearching = false;
  String? _error;
  String _searchQuery = '';

  MovieProvider(this._movieRepository) {
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
  
  bool get isLoading => _isLoading;
  bool get isLoadingDetails => _isLoadingDetails;
  bool get isSearching => _isSearching;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> _loadInitialData() async {
    _setLoading(true);
    
    try {
      await Future.wait([
        loadPopularMovies(),
        loadTopRatedMovies(),
        loadNowPlayingMovies(),
      ]);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Load popular movies
  Future<void> loadPopularMovies() async {
    try {
      _popularMovies = await _movieRepository.getPopularMovies();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load top rated movies
  Future<void> loadTopRatedMovies() async {
    try {
      _topRatedMovies = await _movieRepository.getTopRatedMovies();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load now playing movies
  Future<void> loadNowPlayingMovies() async {
    try {
      _nowPlayingMovies = await _movieRepository.getNowPlayingMovies();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Load upcoming movies
  Future<void> loadUpcomingMovies() async {
    try {
      _upcomingMovies = await _movieRepository.getUpcomingMovies();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

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

  // Get movies by genre
  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    try {
      return await _movieRepository.getMoviesByGenre(genreId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
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