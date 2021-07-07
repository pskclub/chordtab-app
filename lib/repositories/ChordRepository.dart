import 'dart:convert';

import 'package:chordtab/core/Requester.dart';
import 'package:chordtab/models/ChordTileListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class Status {
  bool isSuccess = false;
  bool isError = false;
  bool isLoading = false;
  bool isLoaded = false;

  setSuccess() {
    isSuccess = true;
    isError = false;
    isLoading = false;
    isLoaded = true;
  }

  setError() {
    isSuccess = false;
    isError = true;
    isLoading = false;
    isLoaded = true;
  }

  setLoading() {
    isSuccess = false;
    isError = false;
    isLoading = true;
    isLoaded = false;
  }
}

class ChordRepository with ChangeNotifier {
  ChordTileListModel meta = ChordTileListModel.init();
  Status fetchStatus = Status();

  Future<void> fetch() async {
    fetchStatus.setLoading();
    notifyListeners();
    try {
      var response = await Requester.get(
          "/videos",
          RequesterOptions(
            baseUrl: "https://api.anyaox.com",
          ));
      Map<String, dynamic> map = json.decode(response.toString());
      meta = ChordTileListModel.fromJson(map);
      fetchStatus.setSuccess();
      notifyListeners();
    } on DioError catch (e) {
      fetchStatus.setError();
      notifyListeners();
    }
  }
}
