import 'dart:developer';

import 'package:chordtab/core/Requester.dart';
import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ChordUseCase with ChangeNotifier {
  ChordRepository chordRepo = ChordRepository();
  Map<String, List<ChordTileItemModel>> _searchItems = {};
  Map<String, Status> _searchStatus = {};
  CancelToken? _searchCancelToken;

  ChordTileItemModel? findMeta;
  String findDoChordMeta = '';
  Status findStatus = Status();
  Status findDoChordStatus = Status();

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
    if (_searchCancelToken != null) {
      _searchCancelToken?.cancel('cancelled');
    }
    getSearchStatus(key).setLoading();
    notifyListeners();
    try {
      _searchCancelToken = CancelToken();
      _searchItems[key] = await chordRepo.search(q, cancelToken: _searchCancelToken);
      getSearchStatus(key).setSuccess();
      notifyListeners();
    } on DioError catch (e) {
      if (!CancelToken.isCancel(e)) {
        getSearchStatus(key).setError(e);
        notifyListeners();
      }
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

  Future<void> findDoChord(ChordTileItemModel chord) async {
    findDoChordStatus.setLoading();
    notifyListeners();
    try {
      var res = await Requester.get(chord.link);
      String html = await rootBundle.loadString('assets/do-chord.html');
      findDoChordMeta = html + res.toString();
      findDoChordStatus.setSuccess();
      notifyListeners();
    } on DioError catch (e) {
      findDoChordStatus.setError(e);
      notifyListeners();
    }
  }
}
