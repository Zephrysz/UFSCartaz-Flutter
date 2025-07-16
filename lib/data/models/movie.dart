import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
@Entity(tableName: 'movies')
class Movie {
  @PrimaryKey()
  final int id;
  
  final String title;
  
  @JsonKey(name: 'original_title')
  final String originalTitle;
  
  final String overview;
  
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  
  @JsonKey(name: 'release_date')
  final String releaseDate;
  
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  
  @JsonKey(name: 'vote_count')
  final int voteCount;
  
  final bool adult;
  
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;
  
  final bool video;
  
  final double popularity;
  
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  
  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.genreIds,
    required this.video,
    required this.popularity,
    required this.originalLanguage,
  });
  
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  
  Map<String, dynamic> toJson() => _$MovieToJson(this);
  
  String get fullPosterUrl => posterPath != null 
    ? 'https://image.tmdb.org/t/p/w500$posterPath' 
    : '';
  
  String get fullBackdropUrl => backdropPath != null 
    ? 'https://image.tmdb.org/t/p/w500$backdropPath' 
    : '';
  
  String get formattedRating => voteAverage.toStringAsFixed(1);
  
  String get releaseYear => releaseDate.isNotEmpty && releaseDate.length >= 4 
    ? releaseDate.substring(0, 4) 
    : '';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie &&
          runtimeType == other.runtimeType &&
          id == other.id;
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() {
    return 'Movie{id: $id, title: $title, releaseDate: $releaseDate}';
  }
} 