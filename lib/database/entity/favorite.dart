import 'package:floor/floor.dart';

@entity
class Favorite {
  Favorite(
      this.id,
      this.url,
      this.title,
      this.user,
      );

  @PrimaryKey(autoGenerate: false)
  final String id;
  String url;
  String title;
  String user;

}