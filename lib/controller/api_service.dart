import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:wallpaperify/model/model_category.dart';
import 'package:wallpaperify/model/models_photo.dart';

class Api {
  static const String _apiKey =
      "HAWBZNssVzj2he7iaks5BxUtGoWGk9vlVRes8nkK7CFhEL0ZFgCOS70W";

  static Future<List<GetPhotos>> getTrendingWallpapers() async {
    List<GetPhotos> trending = [];

    final url = Uri.parse("https://api.pexels.com/v1/curated?per_page=30");
    final response = await http.get(url, headers: {"Authorization": _apiKey});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List photos = jsonData['photos'];

      for (var element in photos) {
        trending.add(GetPhotos.fromAPI2App(element));
      }
    }

    return trending;
  }

  static Future<List<GetPhotos>> searchWallpapers(String query) async {
    List<GetPhotos> searchList = [];

    final url = Uri.parse(
        "https://api.pexels.com/v1/search?query=$query&per_page=40&page=1");

    final response = await http.get(url, headers: {"Authorization": _apiKey});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List photos = jsonData['photos'];

      for (var element in photos) {
        searchList.add(GetPhotos.fromAPI2App(element));
      }
    }

    return searchList;
  }

  // ✅ FIXED CATEGORIES
  static Future<List<CategoryModel>> getCategoriesList() async {
    List<CategoryModel> finalList = [];

    List<String> categoryNames = [
      "iphone",
      "Cars",
      "Nature",
      "Bikes",
      "Street",
      "City",
      "coding",
      "Flowers",
    ];

    for (String cat in categoryNames) {
      final photos = await searchWallpapers(cat);

      if (photos.isNotEmpty) {
        final randomPhoto = photos[Random().nextInt(photos.length)];
        finalList.add(CategoryModel(
          catImgUrl: randomPhoto.imgSrc,
          catName: cat,
        ));
      }
    }

    return finalList;
  }
}
