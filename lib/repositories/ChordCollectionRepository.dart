import 'dart:convert';

import 'package:chordtab/models/ChordCollectionItemModel.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/utils/Crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChordCollectionRepository {
  final String key = 'collections';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<ChordCollectionItemModel>> list() async {
    var prefs = await _prefs;
    var collections = prefs.getString(key);
    if (collections == null || collections.isEmpty) {
      collections = jsonEncode([]);
    }

    var collectionsMap = jsonDecode(collections);
    return List<ChordCollectionItemModel>.from(collectionsMap.map((model) => ChordCollectionItemModel.fromJson(model)));
  }

  Future<ChordCollectionItemModel?> find(String collectionId) async {
    var collections = await list();
    return collections.firstWhereOrNull((item) => item.id == collectionId);
  }

  Future<ChordCollectionItemModel?> findByName(String name) async {
    name = name.trim();
    var collections = await list();
    return collections.firstWhereOrNull((item) => item.name == name);
  }

  Future<List<ChordCollectionItemModel>> add(String name) async {
    name = name.trim();
    if (await findByName(name) != null) {
      return list();
    }

    var prefs = await _prefs;
    var collections = await list();
    collections = [ChordCollectionItemModel(id: Crypto.generateMd5(name), name: name), ...collections];
    await prefs.setString(key, jsonEncode(collections));
    return collections;
  }

  Future<List<ChordCollectionItemModel>> delete(String collectionId) async {
    if (await find(collectionId) == null) {
      return list();
    }

    var prefs = await _prefs;
    var collections = await list();
    collections.removeWhere((item) => item.id == collectionId);
    await prefs.setString(key, jsonEncode(collections));
    await prefs.remove('$key.$collectionId');
    return collections;
  }

  Future<List<ChordItemModel>> listChords(String collectionId) async {
    var prefs = await _prefs;
    var chords = prefs.getString('$key.$collectionId');
    if (chords == null || chords.isEmpty) {
      chords = jsonEncode([]);
    }

    var chordsMap = jsonDecode(chords);
    return List<ChordItemModel>.from(chordsMap.map((model) => ChordItemModel.fromJson(model)));
  }

  Future<ChordItemModel?> findChord(String collectionId, String chordId) async {
    var chords = await listChords(collectionId);
    return chords.firstWhereOrNull((item) => item.id == chordId);
  }

  Future<List<ChordItemModel>> deleteChord(String collectionId, String chordId) async {
    if (await findChord(collectionId, chordId) == null) {
      return listChords(collectionId);
    }

    var prefs = await _prefs;
    var chords = await listChords(collectionId);
    chords.removeWhere((item) => item.id == chordId);
    await prefs.setString('$key.$collectionId', jsonEncode(chords));
    return chords;
  }

  Future<List<ChordItemModel>> addChord(String collectionId, ChordItemModel item) async {
    if (await findChord(collectionId, item.id) != null) {
      return listChords(collectionId);
    }

    var prefs = await _prefs;
    var chords = await listChords(collectionId);
    chords = [item, ...chords];
    await prefs.setString('$key.$collectionId', jsonEncode(chords));
    return chords;
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
