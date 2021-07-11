import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/repositories/ChordFavoriteRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChordFavoriteUseCase with ChangeNotifier {
  StatusList<ChordItemModel> fetchResult = StatusList();
  StatusList<ChordItemModel> addResult = StatusList();
  StatusList<ChordItemModel> deleteResult = StatusList();
  final favoriteRepo = ChordFavoriteRepository();

  Future<void> fetch() async {
    fetchResult.setLoading();
    notifyListeners();
    try {
      fetchResult.setSuccess(await favoriteRepo.list());
      notifyListeners();
    } on DioError catch (e) {
      fetchResult.setError(e);
      notifyListeners();
    }
  }

  Future<void> add(ChordItemModel chord) async {
    addResult.setLoading();
    notifyListeners();
    try {
      addResult.setSuccess(await favoriteRepo.add(chord));
      fetchResult.items = addResult.items;
      notifyListeners();
    } on DioError catch (e) {
      addResult.setError(e);
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    deleteResult.setLoading();
    notifyListeners();
    try {
      deleteResult.setSuccess(await favoriteRepo.delete(id));
      fetchResult.items = deleteResult.items;
      notifyListeners();
    } on DioError catch (e) {
      deleteResult.setError(e);
      notifyListeners();
    }
  }
}
