class AppConstants {
  static const String tmdbApiKey = 'f32d65809fe49819cbb0c9691ee6987a';
  static const String pexelsApiKey = 'Ii4GbNTTJzHt85FKWBfNKeueXMJiQD5HPeBYRm2KUdUfAGzJ5U4JP6nf';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String pexelsApiUrl = 'https://api.pexels.com/v1';
  
  static const String dbName = 'ufscartaz_database.db';
  static const int dbVersion = 1;
  
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyUserId = 'userId';
  static const String keyUserName = 'userName';
  static const String keyUserEmail = 'userEmail';
  static const String keyUserAvatar = 'userAvatar';
  static const String keyThemeMode = 'themeMode';
  static const String keyLanguage = 'language';
  
  static const Map<String, int> movieGenres = {
    'action': 28,
    'adventure': 12,
    'animation': 16,
    'comedy': 35,
    'crime': 80,
    'documentaries': 99,
    'drama': 18,
    'family': 10751,
    'fantasy': 14,
    'history': 36,
    'horror': 27,
    'music': 10402,
    'mystery': 9648,
    'romance': 10749,
    'scifi': 878,
    'tv_movie': 10770,
    'thriller': 53,
    'war': 10752,
    'western': 37,
  };
  
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 8.0;
  static const double avatarRadius = 40.0;
  static const int moviePosterAspectRatio = 2; 
  
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
} 