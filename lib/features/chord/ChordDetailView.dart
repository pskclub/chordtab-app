import 'dart:io';

import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class ChordDetailView extends StatefulWidget {
  final ChordItemModel chordModel;
  final Function(WebViewPlusController controller)? onWebViewLoaded;

  const ChordDetailView({Key? key, required this.chordModel, this.onWebViewLoaded}) : super(key: key);

  @override
  _ChordDetailViewState createState() =>
      _ChordDetailViewState(chordModel: chordModel, onWebViewLoaded: onWebViewLoaded);
}

class _ChordDetailViewState extends State<ChordDetailView> {
  final ChordItemModel chordModel;
  final Function(WebViewPlusController controller)? onWebViewLoaded;
  WebViewPlusController? _webViewController;
  bool _webLoaded = false;

  _ChordDetailViewState({required this.chordModel, this.onWebViewLoaded});

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
    return Consumer<ChordUseCase>(builder: (BuildContext context, chordUseCase, Widget? child) {
      return _buildBody(chordUseCase);
    });
  }

  Widget _buildBody(ChordUseCase chordUseCase) {
    return chordModel.type == ChordItemType.chordTab ? _buildChordTab(chordUseCase) : _buildDoChord(chordUseCase);
  }

  _buildChordTab(ChordUseCase chordUseCase) {
    return StatusWrapper(
        status: chordUseCase.findResult,
        body: Center(
          child: SingleChildScrollView(
              child: ExtendedImage.network(
            chordUseCase.findResult.data?.image ?? "",
            width: double.infinity,
            fit: BoxFit.fitWidth,
            cache: true,
            loadStateChanged: buildLoadState,
          )),
        ),
        loading: Center(child: CircularProgressIndicator(color: ThemeColors.secondary)));
  }

  _buildDoChord(ChordUseCase chordUseCase) {
    return Column(
      children: [
        Container(
          child: _webLoaded
              ? null
              : Expanded(child: Center(child: CircularProgressIndicator(color: ThemeColors.secondary))),
        ),
        Expanded(
          child: Visibility(
            visible: _webLoaded,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: _buildWebView(),
          ),
        ),
      ],
    );
  }

  _buildWebView() {
    return WebViewPlus(
      initialUrl: chordModel.link,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _webViewController = controller;
        onWebViewLoaded?.call(_webViewController!);
      },
      onPageFinished: (url) {
        _webViewController?.webViewController.evaluateJavascript('''     
                var _key = document.querySelector('#chord-img');
                var _key2 = document.querySelector('.text-tune');
                document.querySelector('#page').innerHTML = document.querySelector('.row.main_chord').outerHTML;
                document.querySelector('.bt-fav-foot').remove();
                document.querySelector('.dk-fav').remove();
                document.querySelector('.div_scroll2').remove();
                document.querySelector('#page').prepend(_key);
                document.querySelector('#page').prepend(_key2);
                document.head.insertAdjacentHTML("beforeend", `
                <style>
                #chord-img { display: none !important; } 
                iframe { display: none !important; } 
                #page { padding-bottom: 50px; padding-top :16px;} 
                body > .ats-overlay-bottom-wrapper-rendered { display: none !important; } 
                #truehits_div { display: none !important; } 
                hr { display: none !important; } 
                .bt-fav-foot { display: none !important; } 
                #ats-overlay_bottom-8 { display: none !important; } 
                #ats-overlay_bottom-6 { display: none !important; } 
                body > button { display: none !important; } 
                blockquote {background-color: transparent !important;padding-top: 0 !important;padding-bottom: 10 !important;}
                </style>`);                           
                       ''');
        setState(() {
          _webLoaded = true;
        });
      },
    );
  }

  Widget? buildLoadState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return Center(child: CircularProgressIndicator(color: ThemeColors.secondary));

      case LoadState.completed:
        // TODO: Handle this case.
        break;
      case LoadState.failed:
        // TODO: Handle this case.
        break;
    }
  }
}
