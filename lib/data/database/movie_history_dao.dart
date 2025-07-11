import 'package:floor/floor.dart';
import '../models/movie_history_entry.dart';

@dao
abstract class MovieHistoryDao {
  @Query('SELECT * FROM movie_history WHERE id = :id')
  Future<MovieHistoryEntry?> getHistoryEntryById(int id);
  
  @Query('SELECT * FROM movie_history WHERE user_id = :userId ORDER BY viewed_at DESC')
  Future<List<MovieHistoryEntry>> getHistoryByUserId(int userId);
  
  @Query('SELECT * FROM movie_history WHERE user_id = :userId ORDER BY viewed_at DESC LIMIT :limit')
  Future<List<MovieHistoryEntry>> getRecentHistoryByUserId(int userId, int limit);
  
  @Query('SELECT * FROM movie_history WHERE user_id = :userId AND movie_id = :movieId')
  Future<MovieHistoryEntry?> getHistoryEntryByUserAndMovie(int userId, int movieId);
  
  @Query('SELECT * FROM movie_history ORDER BY viewed_at DESC')
  Future<List<MovieHistoryEntry>> getAllHistory();
  
  @insert
  Future<int> insertHistoryEntry(MovieHistoryEntry entry);
  
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertHistoryEntries(List<MovieHistoryEntry> entries);
  
  @update
  Future<int> updateHistoryEntry(MovieHistoryEntry entry);
  
  @delete
  Future<int> deleteHistoryEntry(MovieHistoryEntry entry);
  
  @Query('DELETE FROM movie_history WHERE id = :id')
  Future<int?> deleteHistoryEntryById(int id);
  
  @Query('DELETE FROM movie_history WHERE user_id = :userId')
  Future<int?> deleteHistoryByUserId(int userId);
  
  @Query('DELETE FROM movie_history WHERE user_id = :userId AND movie_id = :movieId')
  Future<int?> deleteHistoryEntryByUserAndMovie(int userId, int movieId);
  
  @Query('DELETE FROM movie_history')
  Future<int?> deleteAllHistory();
  
  @Query('SELECT COUNT(*) FROM movie_history WHERE user_id = :userId')
  Future<int?> getHistoryCountByUserId(int userId);
} 