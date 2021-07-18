import 'dart:io';

import 'package:chordtab/core/Requester.dart';
import 'package:chordtab/models/YoutubeItemModel.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeRepository {
  final String baseGoogleAPI = "https://www.google.co.th";
  final String baseUserAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.164 Safari/537.36";

  Future<YoutubeItemModel> find(String q) async {
    try {
      var response = await Requester.get('/search?q=$q site:youtube.com&tbm=vid',
          options: RequesterOptions(baseUrl: baseGoogleAPI, headers: {HttpHeaders.userAgentHeader: baseUserAgent}));
      var res = parse(response.toString()).getElementsByClassName('yuRUbf');

      if (res.length > 0) {
        var linkEle = res[0].querySelector('a');
        var titleEle = res[0].querySelector('.LC20lb');
        if (linkEle != null && titleEle != null) {
          var link = Uri.decodeFull(linkEle.attributes['href'].toString());
          var title = titleEle.text;
          return YoutubeItemModel(id: YoutubePlayer.convertUrlToId(link) ?? '', link: link, title: title, image: '');
        } else {
          throw Exception(null);
        }
      } else {
        throw Exception(null);
      }
    } on DioError catch (e) {
      throw e;
    }
  }
}
