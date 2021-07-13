import 'package:chordtab/core/Status.dart';
import 'package:chordtab/models/ChordCollectionItemModel.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/repositories/ChordCollectionRepository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChordCollectionUseCase with ChangeNotifier {
  StatusList<ChordCollectionItemModel> fetchResult = StatusList();
  StatusList<ChordCollectionItemModel> deleteResult = StatusList();
  StatusList<ChordCollectionItemModel> addResult = StatusList();
  StatusList<ChordItemModel> fetchChordsResult = StatusList();
  StatusList<ChordItemModel> addChordResult = StatusList();
  StatusList<ChordItemModel> deleteChordResult = StatusList();

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

  Future<void> delete(String id) async {
    deleteResult.setLoading();
    notifyListeners();
    try {
      deleteResult.setSuccess(await _collectionRepo.delete(id));
      fetchResult.items = deleteResult.items;
      notifyListeners();
    } on DioError catch (e) {
      deleteResult.setError(e);
      notifyListeners();
    }
  }

  Future<void> fetchChords(String collectionId) async {
    fetchChordsResult.setLoading();
    notifyListeners();
    try {
      fetchChordsResult.setSuccess(await _collectionRepo.listChords(collectionId));
      notifyListeners();
    } on DioError catch (e) {
      fetchChordsResult.setError(e);
      notifyListeners();
    }
  }

  Future<void> addChord(String collectionId, ChordItemModel chord) async {
    addChordResult.setLoading();
    notifyListeners();
    try {
      addChordResult.setSuccess(await _collectionRepo.addChord(collectionId, chord));
      fetchChordsResult.items = addChordResult.items;
      notifyListeners();
    } on DioError catch (e) {
      addChordResult.setError(e);
      notifyListeners();
    }
  }

  Future<void> deleteChord(String collectionId, String chordId) async {
    deleteChordResult.setLoading();
    notifyListeners();
    try {
      deleteChordResult.setSuccess(await _collectionRepo.deleteChord(collectionId, chordId));
      fetchChordsResult.items = deleteChordResult.items;
      notifyListeners();
    } on DioError catch (e) {
      deleteChordResult.setError(e);
      notifyListeners();
    }
  }
}
