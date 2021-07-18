import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/features/chord/ChordDetailView.dart';
import 'package:chordtab/features/chord/ChordItemBottomSheet.dart';
import 'package:chordtab/features/chord/ChordYoutubePlayerView.dart';
import 'package:chordtab/features/chord/ChrodHowToView.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_tab_indicator_styler/flutter_tab_indicator_styler.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class ChordSinglePage extends StatefulWidget {
  final ChordItemModel chordModel;

  const ChordSinglePage({Key? key, required this.chordModel}) : super(key: key);

  @override
  _ChordSinglePageState createState() => _ChordSinglePageState(chordModel: chordModel);
}

class _ChordSinglePageState extends State<ChordSinglePage> {
  final ChordItemModel chordModel;
  WebViewPlusController? _webViewController;
  int _pageIndex = 0;

  _ChordSinglePageState({required this.chordModel});

  @override
  Widget build(BuildContext context) {
    List<Widget> tabBarList = [
      ChordDetailView(
        chordModel: chordModel,
        onWebViewLoaded: (controller) {
          _webViewController = controller;
        },
      ),
      ChordYoutubePlayerView(
        chordModel: chordModel,
      )
    ];

    List<Widget> tabMenuList = [
      Container(width: 60, height: 30, alignment: Alignment.center, child: Text("คอร์ด")),
      Container(width: 60, height: 30, alignment: Alignment.center, child: Text("วิดีโอ"))
    ];

    if (chordModel.type == ChordItemType.chordTab) {
      tabBarList.insert(1, ChordToView());
      tabMenuList.insert(
        1,
        Container(width: 80, height: 30, alignment: Alignment.center, child: Text("วิธีจับคอร์ด")),
      );
    }

    return DefaultTabController(
      length: chordModel.type == ChordItemType.doChord ? 2 : 3,
      initialIndex: 0,
      child: DefaultLayout(
        title: Text(chordModel.title),
        appBarElevation: 0,
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
        floatingActionButton:
            chordModel.type == ChordItemType.doChord && _pageIndex == 0 ? _buildDoChordFloatingButton() : null,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 15),
              color: ThemeColors.primary,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    color: ThemeColors.primaryDark,
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      isScrollable: true,
                      tabs: tabMenuList,
                      labelColor: Colors.white,
                      indicator: RectangularIndicator(
                          bottomLeftRadius: 100,
                          bottomRightRadius: 100,
                          topLeftRadius: 100,
                          topRightRadius: 100,
                          color: ThemeColors.bg2),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: tabBarList,
              ),
            ),
          ],
        ),
      ),
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
          onTap: () => _webViewController?.webViewController.evaluateJavascript('key_original();'),
        ),
        SpeedDialChild(
          child: Icon(Icons.remove),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'ลดคีย์',
          onTap: () => _webViewController?.webViewController.evaluateJavascript('key_minus();'),
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'เพิ่มคีย์',
          onTap: () => _webViewController?.webViewController.evaluateJavascript('key_plus();'),
        ),
        SpeedDialChild(
          child: Icon(Icons.stop),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'หยุดเลื่อน',
          onTap: () {
            _webViewController?.webViewController.evaluateJavascript('clearInterval(asint);');
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.keyboard_arrow_down_sharp),
          foregroundColor: ThemeColors.primary,
          backgroundColor: Colors.white,
          label: 'เลื่อน',
          onTap: () {
            _webViewController?.webViewController.evaluateJavascript('''
                clearInterval(asint);
                astart = 1.2;
                asint = window.setInterval(autoscroll, 200 / astart);
                jQuery('#speed').html('1x');
                jQuery('div#autoscroll').stop();
                 ''');
          },
        ),
      ],
    );
  }
}
