import 'package:floor/floor.dart';
import 'package:shopper/database/entity/favorite.dart';

@dao
abstract class FavoriteDao {

  @Query('SELECT * FROM Favorite WHERE user = :user')
  Future<List<Favorite>> findAllFavorite(String user);

  @Query('SELECT * FROM Favorite WHERE id = :id')
  Future<Favorite> findFavoriteById(String id);

  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<int> insertFavorite(Favorite favorite);

  @Update(onConflict: OnConflictStrategy.REPLACE)
  Future<void> updateFavorite(Favorite favorite);

  @delete
  Future<void> deleteFavorite(Favorite favorite);

}