import 'dart:io';

import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/features/chord/ChordItemBottomSheet.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../core/App.dart';

class ChordSinglePage extends StatefulWidget {
  final ChordItemModel chordModel;

  const ChordSinglePage({Key? key, required this.chordModel}) : super(key: key);

  @override
  _ChordSinglePageState createState() => _ChordSinglePageState(chordModel: chordModel);
}

class _ChordSinglePageState extends State<ChordSinglePage> {
  final ChordItemModel chordModel;
  WebViewPlusController? _controller;
  bool _webLoaded = false;
  bool _isScrolling = false;

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
    return DefaultLayout(
      title: Text(chordModel.title),
      appBarActions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ChordItemBottomSheet.build(context, chordModel, () {
              Navigator.pop(context);
              ChordItemBottomSheet.buildSelectCollection(context, chordModel);
            });
          },
        ),
      ],
      floatingActionButton: chordModel.type == ChordItemType.doChord ? _buildDoChordFloatingButton() : null,
      body: Consumer<ChordUseCase>(builder: (BuildContext context, chordUseCase, Widget? child) {
        return _buildBody(chordUseCase);
      }),
    );
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
                #page { padding-bottom: 50px; } 
                body > .ats-overlay-bottom-wrapper-rendered { display: none !important; } 
                #truehits_div { display: none !important; } 
                hr { display: none !important; } 
                .bt-fav-foot { display: none !important; } 
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
    );
  }

  Widget _buildDoChordFloatingButton() {
    return SpeedDial(
      icon: Icons.settings,
      activeIcon: Icons.close,
      spacing: 3,
      backgroundColor: ThemeColors.primary,
      foregroundColor: Colors.white,
      closeManually: true,
      children: [
        SpeedDialChild(
          child: Icon(Icons.circle),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'คีย์เริ่มต้น',
          onTap: () => _controller?.webViewController.evaluateJavascript('key_original();'),
        ),
        SpeedDialChild(
          child: Icon(Icons.remove),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'ลดคีย์',
          onTap: () => _controller?.webViewController.evaluateJavascript('key_minus();'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'เพิ่มคีย์',
          onTap: () => _controller?.webViewController.evaluateJavascript('key_plus();'),
        ),
        SpeedDialChild(
          child: Icon(Icons.stop),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'หยุดเลื่อน',
          onTap: () {
            _controller?.webViewController.evaluateJavascript('clearInterval(asint);');
            setState(() {
              _isScrolling = false;
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_arrow_down_sharp),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'เลื่อน',
          onTap: () {
            _controller?.webViewController.evaluateJavascript('''
                clearInterval(asint);
                astart = 1.2;
                asint = window.setInterval(autoscroll, 200 / astart);
                jQuery('#speed').html('1x');
                jQuery('div#autoscroll').stop();
                 ''');
            setState(() {
              _isScrolling = true;
            });
          },
        ),
      ],
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
