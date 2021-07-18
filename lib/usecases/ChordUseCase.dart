import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/models/YoutubeItemModel.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:chordtab/repositories/YoutubeRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChordUseCase with ChangeNotifier {
  ChordRepository _chordRepo = ChordRepository();
  YoutubeRepository _youtubeRepo = YoutubeRepository();
  Map<String, StatusList<ChordItemModel>> _searchResult = {};
  CancelToken? _searchCancelToken;
  Status<ChordItemModel> findResult = Status();
  Status<YoutubeItemModel> findYoutubeResult = Status();

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

  Future<void> findYoutube(String q, {Function(Status<YoutubeItemModel> result)? onSuccess}) async {
    findYoutubeResult.setLoading();
    notifyListeners();
    try {
      findYoutubeResult.setSuccess(await _youtubeRepo.find(q));
      notifyListeners();
    } on DioError catch (e) {
      findYoutubeResult.setError(e);
      notifyListeners();
      onSuccess?.call(findYoutubeResult);
    }
  }
}
