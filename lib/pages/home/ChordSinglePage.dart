import 'dart:io';

import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../core/App.dart';

class ChordSinglePage extends StatefulWidget {
  final ChordTileItemModel chordModel;

  const ChordSinglePage({Key? key, required this.chordModel}) : super(key: key);

  @override
  _ChordSinglePageState createState() => _ChordSinglePageState(chordModel: chordModel);
}

class _ChordSinglePageState extends State<ChordSinglePage> {
  final ChordTileItemModel chordModel;
  WebViewPlusController? _controller;
  bool _webLoaded = false;

  _ChordSinglePageState({required this.chordModel});

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (chordModel.type == ChordItemType.chordTab) {
        App.getUseCase<ChordUseCase>(context, listen: false).find(chordModel);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var chord = App.getUseCase<ChordUseCase>(context);
    return DefaultLayout(body: buildBody(chord), title: Text(chordModel.title), appBarActions: [
      IconButton(
        icon: const Icon(Icons.more_vert),
        tooltip: 'Show Snackbar',
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: ThemeColors.primary,
              context: context,
              builder: (context) {
                return buildBottomSheet(context);
              });
        },
      ),
    ]);
  }

  buildBody(ChordUseCase chord) {
    return chordModel.type == ChordItemType.chordTab ? _buildChordTab(chord) : _buildDoChord(chord);
  }

  Column buildBottomSheet(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: new Icon(Icons.collections),
          title: new Text('คอลเลกชั่น'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: new Icon(Icons.favorite),
          title: new Text('รายการโปรด'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  _buildChordTab(ChordUseCase chord) {
    return StatusWrapper(
        status: chord.findResult,
        body: Center(
          child: SingleChildScrollView(
              child: ExtendedImage.network(
            chord.findResult.data?.image ?? "",
            width: double.infinity,
            fit: BoxFit.fitWidth,
            cache: false,
            loadStateChanged: buildLoadState,
          )),
        ),
        loading: Center(child: CircularProgressIndicator(color: ThemeColors.colors)));
  }

  _buildDoChord(ChordUseCase chord) {
    return Visibility(
      visible: _webLoaded,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller?.webViewController.evaluateJavascript('key_minus();');
                  },
                  child: const Text('ลดคีย์'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _controller?.webViewController.evaluateJavascript('key_plus();');
                  },
                  child: const Text('เพิ่มคีย์'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _controller?.webViewController.evaluateJavascript('key_original();');
                  },
                  child: const Text('คีย์เริ่มต้น'),
                ),
              ],
            ),
          ),
          Expanded(
            child: WebViewPlus(
              initialUrl: chordModel.link,
              onWebViewCreated: (controller) {
                _controller = controller;
              },
              onPageFinished: (url) {
                _controller?.webViewController.evaluateJavascript('''                      
                  document.querySelector('#page').innerHTML = document.querySelector('.row.main_chord').outerHTML;
                  document.querySelector('.bt-fav-foot').remove();
                  document.querySelector('.dk-fav').remove();
                  document.querySelector('.div_scroll2').remove();
                  document.head.insertAdjacentHTML("beforeend", `
                  <style>
                  iframe { display: none !important; } 
                  body > .ats-overlay-bottom-wrapper-rendered { display: none !important; } 
                  body > .ats-overlay-bottom-padding-block-top { display: none !important; } 
                  body > .ats-overlay-bottom-close-button { display: none !important; } 
                  #truehits_div { display: none !important; } 
                  #ats-overlay_bottom-8 { display: none !important; } 
                  #ats-overlay_bottom-6 { display: none !important; } 
                  body > button { display: none !important; } 
                  .main_chord {padding-top :10px;}
                  blockquote {background-color: transparent !important;padding-top: 0 !important;padding-bottom: 10 !important;}
                  </style>`);                           
                         ''');
                setState(() {
                  _webLoaded = true;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ],
      ),
    );
  }

  Widget? buildLoadState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return Center(child: CircularProgressIndicator(color: ThemeColors.info));

      case LoadState.completed:
        // TODO: Handle this case.
        break;
      case LoadState.failed:
        // TODO: Handle this case.
        break;
    }
  }
}
