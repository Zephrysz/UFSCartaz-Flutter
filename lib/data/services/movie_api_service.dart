import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/movie.dart';

part 'movie_api_service.g.dart';

@JsonSerializable()
class MovieResponse {
  final int page;
  final List<Movie> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) => 
      _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@RestApi(baseUrl: 'https://api.themoviedb.org/3')
abstract class MovieApiService {
  factory MovieApiService(Dio dio, {String baseUrl}) = _MovieApiService;

  @GET('/movie/popular')
  Future<MovieResponse> getPopularMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );

  @GET('/movie/top_rated')
  Future<MovieResponse> getTopRatedMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );

  @GET('/movie/now_playing')
  Future<MovieResponse> getNowPlayingMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );

  @GET('/movie/upcoming')
  Future<MovieResponse> getUpcomingMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
  );

  @GET('/movie/{movie_id}')
  Future<Movie> getMovieDetails(
    @Path('movie_id') int movieId,
    @Query('api_key') String apiKey,
  );

  @GET('/search/movie')
  Future<MovieResponse> searchMovies(
    @Query('api_key') String apiKey,
    @Query('query') String query,
    @Query('page') int page,
  );

  @GET('/discover/movie')
  Future<MovieResponse> getMoviesByGenre(
    @Query('api_key') String apiKey,
    @Query('with_genres') int genreId,
    @Query('page') int page,
  );
} 