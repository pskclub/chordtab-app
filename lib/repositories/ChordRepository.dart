import 'dart:io';

import 'package:chordtab/constants/config.const.dart';
import 'package:chordtab/core/Requester.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

class ChordRepository {
  final String baseAPI = configBaseAPI;

  Future<ChordTileItemModel> find(ChordTileItemModel chord) async {
    try {
      var response = await Requester.get(url: chord.link);
      var document = parse(response.toString());
      var ele = document.querySelector('amp-img[layout="responsive"]');
      if (ele != null) {
        chord.image = 'https://chordtabs.in.th/' + ele.attributes['src'].toString().replaceFirst('.', '');
        return chord;
      } else {
        throw Exception(null);
      }
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<List<ChordTileItemModel>> search(String q) async {
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

      return list;
    } on DioError catch (e) {
      throw e;
    }
  }
}
