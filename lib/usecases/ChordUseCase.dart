import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChordUseCase with ChangeNotifier {
  ChordRepository chordRepo = ChordRepository();
  Map<String, StatusList<ChordTileItemModel>> _searchResult = {};
  CancelToken? _searchCancelToken;
  Status<ChordTileItemModel> findResult = Status();

  StatusList<ChordTileItemModel> getSearchResult(String key) {
    if (!_searchResult.containsKey(key)) {
      _searchResult[key] = StatusList();
    }

    return _searchResult[key]!;
  }

  Future<void> search(String key, String q) async {
    if (_searchCancelToken != null) {
      _searchCancelToken?.cancel();
    }
    getSearchResult(key).setLoading();
    notifyListeners();
    try {
      _searchCancelToken = CancelToken();
      var data = await chordRepo.search(q, cancelToken: _searchCancelToken);
      getSearchResult(key).setSuccess(data);
      notifyListeners();
    } on DioError catch (e) {
      if (!CancelToken.isCancel(e)) {
        getSearchResult(key).setError(e);
        notifyListeners();
      }
    }
  }

  Future<void> find(ChordTileItemModel chord) async {
    findResult.setLoading();
    notifyListeners();
    try {
      var findItem = await chordRepo.find(chord);
      findResult.setSuccess(findItem);
      notifyListeners();
    } on DioError catch (e) {
      findResult.setError(e);
      notifyListeners();
    }
  }
}
