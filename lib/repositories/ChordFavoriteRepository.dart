import 'dart:convert';

import 'package:chordtab/models/ChordItemModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChordFavoriteRepository {
  final String key = 'favorites';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<ChordItemModel>> list() async {
    var prefs = await _prefs;
    var favorites = prefs.getString(key);
    if (favorites == null || favorites.isNotEmpty) {
      favorites = jsonEncode([]);
    }

    var favoritesMap = jsonDecode(favorites);
    return List<ChordItemModel>.from(favoritesMap.map((model) => ChordItemModel.fromJson(model)));
  }

  Future<List<ChordItemModel>> add(ChordItemModel item) async {
    var prefs = await _prefs;
    var favorites = await list();
    favorites.add(item);
    await prefs.setString(key, jsonEncode(favorites));

    return favorites;
  }
}
