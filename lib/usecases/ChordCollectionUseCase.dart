import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordCollectionItemModel.dart';
import 'package:chordtab/repositories/ChordCollectionRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChordCollectionUseCase with ChangeNotifier {
  StatusList<ChordCollectionItemModel> fetchResult = StatusList();
  StatusList<ChordCollectionItemModel> addResult = StatusList();
  final _collectionRepo = ChordCollectionRepository();

  Future<void> fetch() async {
    fetchResult.setLoading();
    notifyListeners();
    try {
      fetchResult.setSuccess(await _collectionRepo.list());
      notifyListeners();
    } on DioError catch (e) {
      fetchResult.setError(e);
      notifyListeners();
    }
  }

  Future<void> add(String name) async {
    addResult.setLoading();
    notifyListeners();
    try {
      addResult.setSuccess(await _collectionRepo.add(name));
      fetchResult.items = addResult.items;
      notifyListeners();
    } on DioError catch (e) {
      addResult.setError(e);
      notifyListeners();
    }
  }
}
