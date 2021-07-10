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
      var response = await Requester.get(chord.link);
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

  Future<List<ChordTileItemModel>> search(String q, {CancelToken? cancelToken}) async {
    try {
      var request = await Future.wait([
        Requester.get("/search?q=คอร์ด $q site:chordtabs.in.th",
            options: RequesterOptions(cancelToken: cancelToken, baseUrl: "https://www.google.co.th", headers: {
              HttpHeaders.userAgentHeader:
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36'
            })),
        Requester.get("/search?q=คอร์ด $q site:dochord.com",
            options: RequesterOptions(cancelToken: cancelToken, baseUrl: "https://www.google.co.th", headers: {
              HttpHeaders.userAgentHeader:
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36'
            })),
      ]);

      var chordTabRequest = request[0];
      var doChordRequest = request[1];

      List<ChordTileItemModel> chordTabList = _buildChordList(chordTabRequest, ChordItemType.chordTab);
      List<ChordTileItemModel> doChordList = _buildChordList(doChordRequest, ChordItemType.doChord);

      return [...chordTabList, ...doChordList];
    } on DioError catch (e) {
      throw e;
    }
  }

  List<ChordTileItemModel> _buildChordList(Response<dynamic> chordTabRequest, ChordItemType type) {
    var chordTabLogo =
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcR3jtkgSaeZa_v4dkRYWL0xgEH8JFsIxswfzLch3HKVIAJaE8bg02LFHCHt";
    var doChordLogo = "https://www.dochord.com/wp-content/uploads/2018/04/dochord-logo-sm.png";

    var res = parse(chordTabRequest.toString()).getElementsByClassName('yuRUbf');

    List<ChordTileItemModel> list = [];
    for (var prop in res) {
      var linkEle = prop.querySelector('a');
      var titleEle = prop.querySelector('.LC20lb');
      if (linkEle != null && titleEle != null) {
        var link = Uri.decodeFull(linkEle.attributes['href'].toString())
            .replaceFirst("คอร์ดเพลง", "คอร์ดกีต้าร์")
            .replaceFirst("เนื้อเพลง", "คอร์ดกีต้าร์")
            .replaceFirst("ฟังเพลง", "คอร์ดกีต้าร์")
            .replaceFirst("เพลง", "คอร์ดกีต้าร์");

        var title = titleEle.text;
        if (type == ChordItemType.chordTab) {
          title = titleEle.text
              .replaceFirst("คอร์ดเพลง ", "")
              .replaceFirst("คอร์ด ", "")
              .replaceFirst("คอร์ดกีต้าร์ ", "")
              .replaceFirst("เนื้อเพลง ", "")
              .replaceFirst("เพลง ", "")
              .replaceFirst(" - Chordtabs", "");
          if (link.contains("คอร์ดกีต้าร์")) {
            list.add(ChordTileItemModel(title: title, cover: chordTabLogo, id: '1', image: '', link: link, type: type));
          }
        }

        if (type == ChordItemType.doChord) {
          if (title.contains("คอร์ดเพลง") && !link.contains("artist")) {
            title = titleEle.text
                .replaceFirst("คอร์ดเพลง ", "")
                .replaceFirst("คอร์ด ", "")
                .replaceFirst("คอร์ดกีต้าร์ ", "")
                .replaceFirst("เนื้อเพลง ", "")
                .replaceFirst("เพลง ", "")
                .replaceFirst(" | dochord.com", "");

            list.add(ChordTileItemModel(title: title, cover: doChordLogo, id: '1', image: '', link: link, type: type));
          }
        }
      }
    }

    final titles = list.map((e) => e.title).toSet();
    list.retainWhere((x) => titles.remove(x.title));

    final links = list.map((e) => e.link).toSet();
    list.retainWhere((x) => links.remove(x.link));

    return list;
  }
}
