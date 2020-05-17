import 'database.dart';

class DatabaseFactory {

  static ShopperDatabase _database;

  DatabaseFactory._privateConstructor();
  static final DatabaseFactory instance = DatabaseFactory._privateConstructor();

  Future<ShopperDatabase> get() async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();
      return _database;
    }
  }

  Future<ShopperDatabase> initDB() async {

    return await $FloorShopperDatabase
        .databaseBuilder('Shopper.db')
        .build();

  }

}