// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_history_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieHistoryEntry _$MovieHistoryEntryFromJson(Map<String, dynamic> json) =>
    MovieHistoryEntry(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['userId'] as num).toInt(),
      movieId: (json['movieId'] as num).toInt(),
      movieTitle: json['movieTitle'] as String,
      moviePosterPath: json['moviePosterPath'] as String?,
      viewedAt: DateTime.parse(json['viewedAt'] as String),
    );

Map<String, dynamic> _$MovieHistoryEntryToJson(MovieHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'movieId': instance.movieId,
      'movieTitle': instance.movieTitle,
      'moviePosterPath': instance.moviePosterPath,
      'viewedAt': instance.viewedAt.toIso8601String(),
    };
