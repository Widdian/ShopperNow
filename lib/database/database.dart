// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:shopper/database/dao/favoriteDao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/favorite.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Favorite])
abstract class ShopperDatabase extends FloorDatabase {
  FavoriteDao get favoriteDao;

}