// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorShopperDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ShopperDatabaseBuilder databaseBuilder(String name) =>
      _$ShopperDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$ShopperDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$ShopperDatabaseBuilder(null);
}

class _$ShopperDatabaseBuilder {
  _$ShopperDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$ShopperDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$ShopperDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<ShopperDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$ShopperDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ShopperDatabase extends ShopperDatabase {
  _$ShopperDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FavoriteDao _favoriteDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
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
            'CREATE TABLE IF NOT EXISTS `Favorite` (`id` TEXT, `url` TEXT, `title` TEXT, `user` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  FavoriteDao get favoriteDao {
    return _favoriteDaoInstance ??= _$FavoriteDao(database, changeListener);
  }
}

class _$FavoriteDao extends FavoriteDao {
  _$FavoriteDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _favoriteInsertionAdapter = InsertionAdapter(
            database,
            'Favorite',
            (Favorite item) => <String, dynamic>{
                  'id': item.id,
                  'url': item.url,
                  'title': item.title,
                  'user': item.user
                }),
        _favoriteUpdateAdapter = UpdateAdapter(
            database,
            'Favorite',
            ['id'],
            (Favorite item) => <String, dynamic>{
                  'id': item.id,
                  'url': item.url,
                  'title': item.title,
                  'user': item.user
                }),
        _favoriteDeletionAdapter = DeletionAdapter(
            database,
            'Favorite',
            ['id'],
            (Favorite item) => <String, dynamic>{
                  'id': item.id,
                  'url': item.url,
                  'title': item.title,
                  'user': item.user
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _favoriteMapper = (Map<String, dynamic> row) => Favorite(
      row['id'] as String,
      row['url'] as String,
      row['title'] as String,
      row['user'] as String);

  final InsertionAdapter<Favorite> _favoriteInsertionAdapter;

  final UpdateAdapter<Favorite> _favoriteUpdateAdapter;

  final DeletionAdapter<Favorite> _favoriteDeletionAdapter;

  @override
  Future<List<Favorite>> findAllFavorite(String user) async {
    return _queryAdapter.queryList('SELECT * FROM Favorite WHERE user = ?',
        arguments: <dynamic>[user], mapper: _favoriteMapper);
  }

  @override
  Future<Favorite> findFavoriteById(String id) async {
    return _queryAdapter.query('SELECT * FROM Favorite WHERE id = ?',
        arguments: <dynamic>[id], mapper: _favoriteMapper);
  }

  @override
  Future<int> insertFavorite(Favorite favorite) {
    return _favoriteInsertionAdapter.insertAndReturnId(
        favorite, sqflite.ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateFavorite(Favorite favorite) async {
    await _favoriteUpdateAdapter.update(
        favorite, sqflite.ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteFavorite(Favorite favorite) async {
    await _favoriteDeletionAdapter.delete(favorite);
  }
}
