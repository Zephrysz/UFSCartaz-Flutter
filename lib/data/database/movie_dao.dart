import 'package:floor/floor.dart';
import '../models/movie.dart';

@dao
abstract class MovieDao {
  @Query('SELECT * FROM movies WHERE id = :id')
  Future<Movie?> getMovieById(int id);
  
  @Query('SELECT * FROM movies')
  Future<List<Movie>> getAllMovies();
  
  @Query('SELECT * FROM movies WHERE title LIKE :query OR overview LIKE :query')
  Future<List<Movie>> searchMovies(String query);
  
  @Query('SELECT * FROM movies ORDER BY popularity DESC LIMIT :limit')
  Future<List<Movie>> getPopularMovies(int limit);
  
  @Query('SELECT * FROM movies ORDER BY vote_average DESC LIMIT :limit')
  Future<List<Movie>> getTopRatedMovies(int limit);
  
  @insert
  Future<int> insertMovie(Movie movie);
  
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertMovies(List<Movie> movies);
  
  @update
  Future<int> updateMovie(Movie movie);
  
  @delete
  Future<int> deleteMovie(Movie movie);
  
  @Query('DELETE FROM movies WHERE id = :id')
  Future<int?> deleteMovieById(int id);
  
  @Query('DELETE FROM movies')
  Future<int?> deleteAllMovies();
  
  @Query('SELECT COUNT(*) FROM movies')
  Future<int?> getMovieCount();
} 