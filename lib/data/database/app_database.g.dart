// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  MovieDao? _movieDaoInstance;

  MovieHistoryDao? _movieHistoryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `password_hash` TEXT NOT NULL, `avatar_url` TEXT, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movies` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `originalTitle` TEXT NOT NULL, `overview` TEXT NOT NULL, `posterPath` TEXT, `backdropPath` TEXT, `releaseDate` TEXT NOT NULL, `voteAverage` REAL NOT NULL, `voteCount` INTEGER NOT NULL, `adult` INTEGER NOT NULL, `genreIds` TEXT NOT NULL, `video` INTEGER NOT NULL, `popularity` REAL NOT NULL, `originalLanguage` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movie_history` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `user_id` INTEGER NOT NULL, `movie_id` INTEGER NOT NULL, `movie_title` TEXT NOT NULL, `movie_poster_path` TEXT, `viewed_at` INTEGER NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE INDEX `index_movie_history_user_id` ON `movie_history` (`user_id`)');
        await database.execute(
            'CREATE INDEX `index_movie_history_movie_id` ON `movie_history` (`movie_id`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }

  @override
  MovieHistoryDao get movieHistoryDao {
    return _movieHistoryDaoInstance ??=
        _$MovieHistoryDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'password_hash': item.passwordHash,
                  'avatar_url': item.avatarUrl,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'password_hash': item.passwordHash,
                  'avatar_url': item.avatarUrl,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'password_hash': item.passwordHash,
                  'avatar_url': item.avatarUrl,
                  'created_at': _dateTimeConverter.encode(item.createdAt),
                  'updated_at': _dateTimeConverter.encode(item.updatedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<User?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            passwordHash: row['password_hash'] as String,
            avatarUrl: row['avatar_url'] as String?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int)),
        arguments: [id]);
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            passwordHash: row['password_hash'] as String,
            avatarUrl: row['avatar_url'] as String?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int)),
        arguments: [email]);
  }

  @override
  Future<User?> getUserByEmailAndPassword(
    String email,
    String passwordHash,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM users WHERE email = ?1 AND password_hash = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            passwordHash: row['password_hash'] as String,
            avatarUrl: row['avatar_url'] as String?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int)),
        arguments: [email, passwordHash]);
  }

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            email: row['email'] as String,
            passwordHash: row['password_hash'] as String,
            avatarUrl: row['avatar_url'] as String?,
            createdAt: _dateTimeConverter.decode(row['created_at'] as int),
            updatedAt: _dateTimeConverter.decode(row['updated_at'] as int)));
  }

  @override
  Future<int?> deleteUserById(int id) async {
    return _queryAdapter.query('DELETE FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> countUsersByEmail(String email) async {
    return _queryAdapter.query('SELECT COUNT(*) FROM users WHERE email = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [email]);
  }

  @override
  Future<int?> getUserCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM users',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateUser(User user) {
    return _userUpdateAdapter.updateAndReturnChangedRows(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteUser(User user) {
    return _userDeletionAdapter.deleteAndReturnChangedRows(user);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieInsertionAdapter = InsertionAdapter(
            database,
            'movies',
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'originalTitle': item.originalTitle,
                  'overview': item.overview,
                  'posterPath': item.posterPath,
                  'backdropPath': item.backdropPath,
                  'releaseDate': item.releaseDate,
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount,
                  'adult': item.adult ? 1 : 0,
                  'genreIds': _listIntConverter.encode(item.genreIds),
                  'video': item.video ? 1 : 0,
                  'popularity': item.popularity,
                  'originalLanguage': item.originalLanguage
                }),
        _movieUpdateAdapter = UpdateAdapter(
            database,
            'movies',
            ['id'],
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'originalTitle': item.originalTitle,
                  'overview': item.overview,
                  'posterPath': item.posterPath,
                  'backdropPath': item.backdropPath,
                  'releaseDate': item.releaseDate,
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount,
                  'adult': item.adult ? 1 : 0,
                  'genreIds': _listIntConverter.encode(item.genreIds),
                  'video': item.video ? 1 : 0,
                  'popularity': item.popularity,
                  'originalLanguage': item.originalLanguage
                }),
        _movieDeletionAdapter = DeletionAdapter(
            database,
            'movies',
            ['id'],
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'originalTitle': item.originalTitle,
                  'overview': item.overview,
                  'posterPath': item.posterPath,
                  'backdropPath': item.backdropPath,
                  'releaseDate': item.releaseDate,
                  'voteAverage': item.voteAverage,
                  'voteCount': item.voteCount,
                  'adult': item.adult ? 1 : 0,
                  'genreIds': _listIntConverter.encode(item.genreIds),
                  'video': item.video ? 1 : 0,
                  'popularity': item.popularity,
                  'originalLanguage': item.originalLanguage
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Movie> _movieInsertionAdapter;

  final UpdateAdapter<Movie> _movieUpdateAdapter;

  final DeletionAdapter<Movie> _movieDeletionAdapter;

  @override
  Future<Movie?> getMovieById(int id) async {
    return _queryAdapter.query('SELECT * FROM movies WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalTitle: row['originalTitle'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String?,
            backdropPath: row['backdropPath'] as String?,
            releaseDate: row['releaseDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            adult: (row['adult'] as int) != 0,
            genreIds: _listIntConverter.decode(row['genreIds'] as String),
            video: (row['video'] as int) != 0,
            popularity: row['popularity'] as double,
            originalLanguage: row['originalLanguage'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Movie>> getAllMovies() async {
    return _queryAdapter.queryList('SELECT * FROM movies',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalTitle: row['originalTitle'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String?,
            backdropPath: row['backdropPath'] as String?,
            releaseDate: row['releaseDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            adult: (row['adult'] as int) != 0,
            genreIds: _listIntConverter.decode(row['genreIds'] as String),
            video: (row['video'] as int) != 0,
            popularity: row['popularity'] as double,
            originalLanguage: row['originalLanguage'] as String));
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    return _queryAdapter.queryList(
        'SELECT * FROM movies WHERE title LIKE ?1 OR overview LIKE ?1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalTitle: row['originalTitle'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String?,
            backdropPath: row['backdropPath'] as String?,
            releaseDate: row['releaseDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            adult: (row['adult'] as int) != 0,
            genreIds: _listIntConverter.decode(row['genreIds'] as String),
            video: (row['video'] as int) != 0,
            popularity: row['popularity'] as double,
            originalLanguage: row['originalLanguage'] as String),
        arguments: [query]);
  }

  @override
  Future<List<Movie>> getPopularMovies(int limit) async {
    return _queryAdapter.queryList(
        'SELECT * FROM movies ORDER BY popularity DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalTitle: row['originalTitle'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String?,
            backdropPath: row['backdropPath'] as String?,
            releaseDate: row['releaseDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            adult: (row['adult'] as int) != 0,
            genreIds: _listIntConverter.decode(row['genreIds'] as String),
            video: (row['video'] as int) != 0,
            popularity: row['popularity'] as double,
            originalLanguage: row['originalLanguage'] as String),
        arguments: [limit]);
  }

  @override
  Future<List<Movie>> getTopRatedMovies(int limit) async {
    return _queryAdapter.queryList(
        'SELECT * FROM movies ORDER BY voteAverage DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int,
            title: row['title'] as String,
            originalTitle: row['originalTitle'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String?,
            backdropPath: row['backdropPath'] as String?,
            releaseDate: row['releaseDate'] as String,
            voteAverage: row['voteAverage'] as double,
            voteCount: row['voteCount'] as int,
            adult: (row['adult'] as int) != 0,
            genreIds: _listIntConverter.decode(row['genreIds'] as String),
            video: (row['video'] as int) != 0,
            popularity: row['popularity'] as double,
            originalLanguage: row['originalLanguage'] as String),
        arguments: [limit]);
  }

  @override
  Future<int?> deleteMovieById(int id) async {
    return _queryAdapter.query('DELETE FROM movies WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteAllMovies() async {
    return _queryAdapter.query('DELETE FROM movies',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getMovieCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM movies',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertMovie(Movie movie) {
    return _movieInsertionAdapter.insertAndReturnId(
        movie, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertMovies(List<Movie> movies) {
    return _movieInsertionAdapter.insertListAndReturnIds(
        movies, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateMovie(Movie movie) {
    return _movieUpdateAdapter.updateAndReturnChangedRows(
        movie, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteMovie(Movie movie) {
    return _movieDeletionAdapter.deleteAndReturnChangedRows(movie);
  }
}

class _$MovieHistoryDao extends MovieHistoryDao {
  _$MovieHistoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieHistoryEntryInsertionAdapter = InsertionAdapter(
            database,
            'movie_history',
            (MovieHistoryEntry item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'movie_id': item.movieId,
                  'movie_title': item.movieTitle,
                  'movie_poster_path': item.moviePosterPath,
                  'viewed_at': _dateTimeConverter.encode(item.viewedAt)
                }),
        _movieHistoryEntryUpdateAdapter = UpdateAdapter(
            database,
            'movie_history',
            ['id'],
            (MovieHistoryEntry item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'movie_id': item.movieId,
                  'movie_title': item.movieTitle,
                  'movie_poster_path': item.moviePosterPath,
                  'viewed_at': _dateTimeConverter.encode(item.viewedAt)
                }),
        _movieHistoryEntryDeletionAdapter = DeletionAdapter(
            database,
            'movie_history',
            ['id'],
            (MovieHistoryEntry item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'movie_id': item.movieId,
                  'movie_title': item.movieTitle,
                  'movie_poster_path': item.moviePosterPath,
                  'viewed_at': _dateTimeConverter.encode(item.viewedAt)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieHistoryEntry> _movieHistoryEntryInsertionAdapter;

  final UpdateAdapter<MovieHistoryEntry> _movieHistoryEntryUpdateAdapter;

  final DeletionAdapter<MovieHistoryEntry> _movieHistoryEntryDeletionAdapter;

  @override
  Future<MovieHistoryEntry?> getHistoryEntryById(int id) async {
    return _queryAdapter.query('SELECT * FROM movie_history WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MovieHistoryEntry(
            id: row['id'] as int?,
            userId: row['user_id'] as int,
            movieId: row['movie_id'] as int,
            movieTitle: row['movie_title'] as String,
            moviePosterPath: row['movie_poster_path'] as String?,
            viewedAt: _dateTimeConverter.decode(row['viewed_at'] as int)),
        arguments: [id]);
  }

  @override
  Future<List<MovieHistoryEntry>> getHistoryByUserId(int userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM movie_history WHERE user_id = ?1 ORDER BY viewed_at DESC',
        mapper: (Map<String, Object?> row) => MovieHistoryEntry(id: row['id'] as int?, userId: row['user_id'] as int, movieId: row['movie_id'] as int, movieTitle: row['movie_title'] as String, moviePosterPath: row['movie_poster_path'] as String?, viewedAt: _dateTimeConverter.decode(row['viewed_at'] as int)),
        arguments: [userId]);
  }

  @override
  Future<List<MovieHistoryEntry>> getRecentHistoryByUserId(
    int userId,
    int limit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM movie_history WHERE user_id = ?1 ORDER BY viewed_at DESC LIMIT ?2',
        mapper: (Map<String, Object?> row) => MovieHistoryEntry(id: row['id'] as int?, userId: row['user_id'] as int, movieId: row['movie_id'] as int, movieTitle: row['movie_title'] as String, moviePosterPath: row['movie_poster_path'] as String?, viewedAt: _dateTimeConverter.decode(row['viewed_at'] as int)),
        arguments: [userId, limit]);
  }

  @override
  Future<MovieHistoryEntry?> getHistoryEntryByUserAndMovie(
    int userId,
    int movieId,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM movie_history WHERE user_id = ?1 AND movie_id = ?2',
        mapper: (Map<String, Object?> row) => MovieHistoryEntry(
            id: row['id'] as int?,
            userId: row['user_id'] as int,
            movieId: row['movie_id'] as int,
            movieTitle: row['movie_title'] as String,
            moviePosterPath: row['movie_poster_path'] as String?,
            viewedAt: _dateTimeConverter.decode(row['viewed_at'] as int)),
        arguments: [userId, movieId]);
  }

  @override
  Future<List<MovieHistoryEntry>> getAllHistory() async {
    return _queryAdapter.queryList(
        'SELECT * FROM movie_history ORDER BY viewed_at DESC',
        mapper: (Map<String, Object?> row) => MovieHistoryEntry(
            id: row['id'] as int?,
            userId: row['user_id'] as int,
            movieId: row['movie_id'] as int,
            movieTitle: row['movie_title'] as String,
            moviePosterPath: row['movie_poster_path'] as String?,
            viewedAt: _dateTimeConverter.decode(row['viewed_at'] as int)));
  }

  @override
  Future<int?> deleteHistoryEntryById(int id) async {
    return _queryAdapter.query('DELETE FROM movie_history WHERE id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<int?> deleteHistoryByUserId(int userId) async {
    return _queryAdapter.query('DELETE FROM movie_history WHERE user_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [userId]);
  }

  @override
  Future<int?> deleteHistoryEntryByUserAndMovie(
    int userId,
    int movieId,
  ) async {
    return _queryAdapter.query(
        'DELETE FROM movie_history WHERE user_id = ?1 AND movie_id = ?2',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [userId, movieId]);
  }

  @override
  Future<int?> deleteAllHistory() async {
    return _queryAdapter.query('DELETE FROM movie_history',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getHistoryCountByUserId(int userId) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM movie_history WHERE user_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [userId]);
  }

  @override
  Future<int> insertHistoryEntry(MovieHistoryEntry entry) {
    return _movieHistoryEntryInsertionAdapter.insertAndReturnId(
        entry, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertHistoryEntries(List<MovieHistoryEntry> entries) {
    return _movieHistoryEntryInsertionAdapter.insertListAndReturnIds(
        entries, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateHistoryEntry(MovieHistoryEntry entry) {
    return _movieHistoryEntryUpdateAdapter.updateAndReturnChangedRows(
        entry, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteHistoryEntry(MovieHistoryEntry entry) {
    return _movieHistoryEntryDeletionAdapter.deleteAndReturnChangedRows(entry);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _listIntConverter = ListIntConverter();
