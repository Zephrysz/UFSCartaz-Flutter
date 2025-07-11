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

@TypeConverters([DateTimeConverter, ListIntConverter])
@Database(
  version: 1,
  entities: [User, Movie, MovieHistoryEntry],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDao;
  MovieDao get movieDao;
  MovieHistoryDao get movieHistoryDao;
  
  static Future<AppDatabase> create() async {
    return await $FloorAppDatabase.databaseBuilder('ufscartaz_database.db').build();
  }
} 