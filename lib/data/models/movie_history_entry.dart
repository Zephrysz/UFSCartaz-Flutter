import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'movie_history_entry.g.dart';

@JsonSerializable()
@Entity(
  tableName: 'movie_history',
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['user_id']),
    Index(value: ['movie_id']),
  ],
)
class MovieHistoryEntry {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  @ColumnInfo(name: 'user_id')
  final int userId;
  
  @ColumnInfo(name: 'movie_id')
  final int movieId;
  
  @ColumnInfo(name: 'movie_title')
  final String movieTitle;
  
  @ColumnInfo(name: 'movie_poster_path')
  final String? moviePosterPath;
  
  @ColumnInfo(name: 'viewed_at')
  final DateTime viewedAt;
  
  MovieHistoryEntry({
    this.id,
    required this.userId,
    required this.movieId,
    required this.movieTitle,
    this.moviePosterPath,
    required this.viewedAt,
  });
  
  factory MovieHistoryEntry.fromJson(Map<String, dynamic> json) => 
      _$MovieHistoryEntryFromJson(json);
  
  Map<String, dynamic> toJson() => _$MovieHistoryEntryToJson(this);
  
  MovieHistoryEntry copyWith({
    int? id,
    int? userId,
    int? movieId,
    String? movieTitle,
    String? moviePosterPath,
    DateTime? viewedAt,
  }) {
    return MovieHistoryEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
      moviePosterPath: moviePosterPath ?? this.moviePosterPath,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }
  
  String get fullPosterUrl => moviePosterPath != null 
    ? 'https://image.tmdb.org/t/p/w500$moviePosterPath' 
    : '';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieHistoryEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'MovieHistoryEntry{id: $id, userId: $userId, movieId: $movieId, movieTitle: $movieTitle}';
  }
} 