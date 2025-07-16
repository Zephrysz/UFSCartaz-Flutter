import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/user.dart';
import '../models/movie.dart';
import '../models/movie_history_entry.dart';
import 'user_dao.dart';
import 'movie_dao.dart';
import 'movie_history_dao.dart';
import 'converters.dart';

part 'app_database.g.dart';

// Migration from version 1 to 2
final migration1to2 = Migration(1, 2, (database) async {
  // Since we changed the video field type from TEXT to INTEGER (for boolean),
  // we need to recreate the movies table
  await database.execute('DROP TABLE IF EXISTS movies');
  await database.execute(
      'CREATE TABLE IF NOT EXISTS `movies` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `originalTitle` TEXT NOT NULL, `overview` TEXT NOT NULL, `posterPath` TEXT, `backdropPath` TEXT, `releaseDate` TEXT NOT NULL, `voteAverage` REAL NOT NULL, `voteCount` INTEGER NOT NULL, `adult` INTEGER NOT NULL, `genreIds` TEXT NOT NULL, `video` INTEGER NOT NULL, `popularity` REAL NOT NULL, `originalLanguage` TEXT NOT NULL, PRIMARY KEY (`id`))');
});

@TypeConverters([DateTimeConverter, ListIntConverter])
@Database(
  version: 2,
  entities: [User, Movie, MovieHistoryEntry],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  MovieDao get movieDao;
  MovieHistoryDao get movieHistoryDao;
  
  static Future<AppDatabase> create() async {
    return await $FloorAppDatabase
        .databaseBuilder('ufscartaz_database.db')
        .addMigrations([migration1to2])
        .build();
  }
} 