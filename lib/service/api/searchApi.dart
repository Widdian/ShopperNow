import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopper/const/url.dart';

class SearchApi {
  static Future<Map> getTrending() async {
    var url = '$searchApi/trending?api_key=$apiKey&limit=20&rating=G';
    Map mapResponse;

    var response = await http.get(url);

    try {
      mapResponse = json.decode(response.body);
    } catch (e) {
      print(e);
    }

    return mapResponse;
  }

  static Future<Map> getGifs(String search, int offset) async {
    var url = '$searchApi/search?api_key=$apiKey&q=$search&limit=21&offset=$offset&rating=G&lang=pt';
    Map mapResponse;

    var response = await http.get(url);

    try {
      mapResponse = json.decode(response.body);
    } catch (e) {
      print(e);
    }

    return mapResponse;
  }
}
