import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChordUseCase with ChangeNotifier {
  ChordRepository _chordRepo = ChordRepository();
  Map<String, StatusList<ChordItemModel>> _searchResult = {};
  CancelToken? _searchCancelToken;
  Status<ChordItemModel> findResult = Status();

  StatusList<ChordItemModel> searchResult(String key) {
    if (!_searchResult.containsKey(key)) {
      _searchResult[key] = StatusList();
    }

    return _searchResult[key]!;
  }

  Future<void> search(String key, String q) async {
    if (_searchCancelToken != null) {
      _searchCancelToken?.cancel();
    }
    searchResult(key).setLoading();
    notifyListeners();
    try {
      _searchCancelToken = CancelToken();
      searchResult(key).setSuccess(await _chordRepo.search(q, cancelToken: _searchCancelToken));
      notifyListeners();
    } on DioError catch (e) {
      if (!CancelToken.isCancel(e)) {
        searchResult(key).setError(e);
        notifyListeners();
      }
    }
  }

  Future<void> find(ChordItemModel chord) async {
    findResult.setLoading();
    notifyListeners();
    try {
      findResult.setSuccess(await _chordRepo.find(chord));
      notifyListeners();
    } on DioError catch (e) {
      findResult.setError(e);
      notifyListeners();
    }
  }
}
