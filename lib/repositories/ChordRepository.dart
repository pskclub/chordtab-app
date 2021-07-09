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

  ChordTileListModel searchMeta = ChordTileListModel.init();
  Status searchStatus = Status();

  ChordTileItemModel? findMeta;
  Status findStatus = Status();

  Future<void> find(ChordTileItemModel chord) async {
    findMeta = null;
    findStatus.setLoading();
    notifyListeners();
    try {
      var response = await Requester.get(url: chord.link);
      var document = parse(response.toString());
      var ele = document.querySelector('amp-img[layout="responsive"]');
      if (ele != null) {
        chord.image = 'https://chordtabs.in.th/' + ele.attributes['src'].toString().replaceFirst('.', '');
        findMeta = chord;
        findStatus.setSuccess();
      } else {
        findStatus.setError();
      }
      notifyListeners();
    } on DioError catch (e) {
      findStatus.setError();
      notifyListeners();
    }
  }

  Future<void> search(String q) async {
    searchStatus.setLoading();
    notifyListeners();
    try {
      var response = await Requester.get(
          url: "/search?q=คอร์ด $q site:chordtabs.in.th",
          options: RequesterOptions(baseUrl: "https://www.google.co.th", headers: {
            HttpHeaders.userAgentHeader:
                'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36'
          }));
      var document = parse(response.toString());
      var res = document.getElementsByClassName('yuRUbf');
      var cover = "https://www.freepnglogos.com/uploads/spotify-logo-png/spotify-simple-green-logo-icon-24.png";
      if (res.length > 0) {
        response = await Requester.get(
            url: "/search?q=รูปปก $q&tbm=isch",
            options: RequesterOptions(baseUrl: "https://google.co.th", headers: {
              HttpHeaders.userAgentHeader:
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36'
            }));
        document = parse(response.toString());
        final elements = document.getElementsByClassName('t0fcAb');
        if (Uri.parse(elements[0].attributes['src'].toString()).isAbsolute) {
          cover = elements[0].attributes['src'].toString();
        }
      }
      List<ChordTileItemModel> list = [];
      for (var prop in res) {
        var linkEle = prop.querySelector('a');
        var titleEle = prop.querySelector('.LC20lb');
        if (linkEle != null && titleEle != null) {
          var link = Uri.decodeFull(linkEle.attributes['href'].toString()).replaceFirst("คอร์ดเพลง", "คอร์ดกีต้าร์");
          if (link.contains("คอร์ดกีต้าร์")) {
            list.add(ChordTileItemModel(title: titleEle.text, cover: cover, id: '1', image: '', link: link));
          }
        }
      }

      searchMeta.items = list;
      searchStatus.setSuccess();
      notifyListeners();
    } on DioError catch (e) {
      searchStatus.setError();
      notifyListeners();
    }
  }
}
