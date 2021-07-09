import 'dart:io';

import 'package:chordtab/constants/config.const.dart';
import 'package:chordtab/core/Requester.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/models/ChordTileListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';

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
  final String baseAPI = configBaseAPI;
  ChordTileListModel meta = ChordTileListModel.init();
  Status fetchStatus = Status();

  Future<void> fetch(String q) async {
    fetchStatus.setLoading();
    notifyListeners();
    try {
      var response = await Requester.get(
          "/search?q=คอร์ด $q site:chordtabs.in.th",
          RequesterOptions(baseUrl: "https://www.google.co.th", headers: {
            HttpHeaders.userAgentHeader:
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36'
          }));
      var document = parse(response.toString());
      var res = document.getElementsByClassName('yuRUbf');
      var image =
          "https://www.freepnglogos.com/uploads/spotify-logo-png/spotify-simple-green-logo-icon-24.png";
      if (res.length > 0) {
        response = await Requester.get(
            "/search?q=รูปปก $q&tbm=isch",
            RequesterOptions(baseUrl: "https://google.co.th", headers: {
              HttpHeaders.userAgentHeader:
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36'
            }));
        document = parse(response.toString());
        final elements = document.getElementsByClassName('t0fcAb');
        image = elements[0].attributes['src'].toString();
      }
      List<ChordTileItemModel> list = [];
      for (var prop in res) {
        var r = prop.getElementsByClassName('LC20lb DKV0Md')[0];
        list.add(ChordTileItemModel(
            title: r.innerHtml.toString(), image: image, id: '1'));
      }

      meta.items = list;
      fetchStatus.setSuccess();
      notifyListeners();
    } on DioError catch (e) {
      fetchStatus.setError();
      notifyListeners();
    }
  }
}
