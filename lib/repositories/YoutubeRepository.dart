import 'dart:developer';
import 'dart:io';

import 'package:chordtab/core/Requester.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

class YoutubeRepository {
  final String baseUserAgent =
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.164 Safari/537.36";

  Future<dynamic> find(String q) async {
    try {
      var response = await Requester.get('https://www.youtube.com/results?search_query=' + q,
          options: RequesterOptions(headers: {HttpHeaders.userAgentHeader: baseUserAgent}));
      var document = parse(response.toString());
      log(response.toString());
      // var eles = document.querySelectorAll('.style-scope.ytd-rich-grid-renderer');
      // print(eles.length);
      // for (var item in eles) {
      //   log(item.innerHtml);
      // }

      log(response.toString());
    } on DioError catch (e) {
      throw e;
    }
  }
}
