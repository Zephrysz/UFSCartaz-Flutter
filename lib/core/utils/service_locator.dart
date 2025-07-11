import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/app_database.dart';
import '../../data/services/movie_api_service.dart';
import '../../data/services/pexels_api_service.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/movie_repository.dart';
import '../../data/repositories/avatar_repository.dart';
import '../constants/app_constants.dart';

class ServiceLocator {
  static late SharedPreferences _preferences;
  static late AppDatabase _database;
  static late Dio _dio;
  static late MovieApiService _movieApiService;
  static late PexelsApiService _pexelsApiService;
  static late UserRepository _userRepository;
  static late MovieRepository _movieRepository;
  static late AvatarRepository _avatarRepository;

  static Future<void> init() async {
    // Initialize SharedPreferences
    _preferences = await SharedPreferences.getInstance();

    // Initialize Database
    _database = await AppDatabase.create();

    // Initialize Dio HTTP client
    _dio = Dio(BaseOptions(
      connectTimeout: Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeout),
    ));

    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    // Initialize API services
    _movieApiService = MovieApiService(_dio);
    _pexelsApiService = PexelsApiService(_dio);

    // Initialize repositories
    _userRepository = UserRepository(_database, _preferences);
    _movieRepository = MovieRepository(_database, _movieApiService);
    _avatarRepository = AvatarRepository(_pexelsApiService);
  }

  // Getters
  static SharedPreferences get preferences => _preferences;
  static AppDatabase get database => _database;
  static Dio get dio => _dio;
  static MovieApiService get movieApiService => _movieApiService;
  static PexelsApiService get pexelsApiService => _pexelsApiService;
  static UserRepository get userRepository => _userRepository;
  static MovieRepository get movieRepository => _movieRepository;
  static AvatarRepository get avatarRepository => _avatarRepository;
} 