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
        body: Consumer<ChordUseCase>(builder: (BuildContext context, chordUseCase, Widget? child) {
          return _buildBody(chordUseCase);
        }),
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
        ]);
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
        loading: Center(child: CircularProgressIndicator(color: ThemeColors.info)));
  }

  _buildDoChord(ChordUseCase chordUseCase) {
    return Column(
      children: [
        Container(
          child: _webLoaded ? null : Expanded(child: Center(child: CircularProgressIndicator(color: ThemeColors.info))),
        ),
        Container(child: _webLoaded ? _buildToolbar() : null),
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
                body > .ats-overlay-bottom-wrapper-rendered { display: none !important; } 
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
    );
  }

  Padding _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToolbarButton(
              text: const Text('ลดคีย์'),
              onPressed: () {
                _controller?.webViewController.evaluateJavascript('key_minus();');
              }),
          SizedBox(width: 8),
          _buildToolbarButton(
              text: const Text('เพิ่มคีย์'),
              onPressed: () {
                _controller?.webViewController.evaluateJavascript('key_plus();');
              }),
          SizedBox(width: 8),
          _buildToolbarButton(
              text: const Text('คีย์เริ่มต้น'),
              onPressed: () {
                _controller?.webViewController.evaluateJavascript('key_original();');
              }),
          SizedBox(width: 8),
          // SizedBox(width: 16),
          // ElevatedButton(
          //   onPressed: () {
          //     _controller?.webViewController.evaluateJavascript('''
          //     astart = 1.2
          //     asint = window.setInterval(autoscroll, 200 / astart)
          //     jQuery('#speed').html('1x')
          //     jQuery('div#autoscroll').stop()
          //     jQuery('div#x').animate({ 'width': '53px' }, 200, 'easeInOutQuint')
          //     jQuery('div#autoscroll').animate({ 'right': '10px' }, 300, 'easeInOutQuint')
          //     jQuery('a#autoscroll em').css({ 'background-position': 'left 27px' })
          //     jQuery('.end-scroll').show()
          //      ''');
          //   },
          //   child: const Text('เลื่อน'),
          // ),
          Container(
            height: 30,
            padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.blue, border: Border.all()),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                value: 'เลื่อน x1',
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {});
                },
                items: <String>['เลื่อน x1', 'เลื่อน x2', 'เลื่อน x3', 'เลื่อน x']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToolbarButton({required Widget text, required VoidCallback? onPressed}) {
    return Container(
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        child: text,
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
