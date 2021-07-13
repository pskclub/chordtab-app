import 'dart:convert';

import 'package:chordtab/models/ChordItemModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChordFavoriteRepository {
  final String key = 'favorites';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<ChordItemModel>> list() async {
    var prefs = await _prefs;
    var favorites = prefs.getString(key);
    if (favorites == null || favorites.isEmpty) {
      favorites = jsonEncode([]);
    }

    var favoritesMap = jsonDecode(favorites);
    return List<ChordItemModel>.from(favoritesMap.map((model) => ChordItemModel.fromJson(model)));
  }

  Future<List<ChordItemModel>> add(ChordItemModel item) async {
    if (await find(item.id) != null) {
      return list();
    }

    var prefs = await _prefs;
    var favorites = await list();
    favorites = [item, ...favorites];
    await prefs.setString(key, jsonEncode(favorites));
    return favorites;
  }

  Future<List<ChordItemModel>> delete(String id) async {
    if (await find(id) == null) {
      return list();
    }

    var prefs = await _prefs;
    var favorites = await list();
    favorites.removeWhere((item) => item.id == id);
    await prefs.setString(key, jsonEncode(favorites));
    return favorites;
  }

  Future<ChordItemModel?> find(String id) async {
    var favorites = await list();
    return favorites.firstWhereOrNull((item) => item.id == id);
  }
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
