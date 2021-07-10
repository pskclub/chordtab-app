import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChordUseCase with ChangeNotifier {
  ChordRepository chordRepo = ChordRepository();
  Map<String, List<ChordTileItemModel>> _searchItems = {};
  Map<String, Status> _searchStatus = {};

  ChordTileItemModel? findMeta;
  Status findStatus = Status();

  Status getSearchStatus(String key) {
    if (!_searchStatus.containsKey(key)) {
      _searchStatus[key] = Status();
    }

    return _searchStatus[key]!;
  }

  List<ChordTileItemModel> getSearchItems(String key) {
    if (!_searchItems.containsKey(key)) {
      _searchItems[key] = List<ChordTileItemModel>.empty();
    }

    return _searchItems[key]!;
  }

  Future<void> search(String key, String q) async {
    getSearchStatus(key).setLoading();
    notifyListeners();
    try {
      _searchItems[key] = await chordRepo.search(q);
      getSearchStatus(key).setSuccess();
      notifyListeners();
    } on DioError catch (e) {
      getSearchStatus(key).setError(e);
      notifyListeners();
    }
  }

  Future<void> find(ChordTileItemModel chord) async {
    findStatus.setLoading();
    notifyListeners();
    try {
      findMeta = await chordRepo.find(chord);
      findStatus.setSuccess();
      notifyListeners();
    } on DioError catch (e) {
      findStatus.setError(e);
      notifyListeners();
    }
  }
}
