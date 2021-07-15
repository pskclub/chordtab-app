import 'package:chordtab/constants/bottom_navbar.const.dart';
import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/features/chord/ChordListLoadingView.dart';
import 'package:chordtab/features/collection/CollectionListView.dart';
import 'package:chordtab/features/collection/EmptyCollectionView.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/AppUseCase.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/App.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  _CollectionPage createState() => _CollectionPage();
}

class _CollectionPage extends State<CollectionPage> {
  TextEditingController _name = TextEditingController();
  String? _nameErrorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      App.getUseCase<ChordCollectionUseCase>(context, listen: false).fetch();
    });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        App.getUseCase<AppUseCase>(context, listen: false).changeTab(BOTTOM_NAVBAR.Home.index, context);
        return false;
      },
      child: DefaultLayout(
          body: Consumer<ChordCollectionUseCase>(builder: (BuildContext context, collectionUseCase, Widget? child) {
            return _buildBody(collectionUseCase);
          }),
          title: Text("คอลเลกชั่น"),
          bottomNavigationBar: BottomNavigationBarView(),
          appBarActions: [
            TextButton(
              onPressed: () {
                _showCreateDialog();
              },
              child: Text(
                'เพิ่ม',
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
    );
  }

  Widget _buildBody(ChordCollectionUseCase collectionUseCase) {
    return StatusWrapper(
        status: collectionUseCase.fetchResult,
        body: EmptyCollectionView(
            isEmpty: collectionUseCase.fetchResult.items.isEmpty,
            child: CollectionListView(items: collectionUseCase.fetchResult.items)),
        loading: ChordListLoadingView());
  }

  _showCreateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              backgroundColor: ThemeColors.primary,
              title: Text(
                "เพิ่มคอลเลกชั่น",
                style: TextStyle(fontSize: 16),
              ),
              content: _buildDialogCreateForm(context),
              actions: [
                TextButton(
                  child: Text(
                    "เพิ่ม",
                    style: TextStyle(color: ThemeColors.info),
                  ),
                  onPressed: () {
                    setState(() {
                      _nameErrorMessage = _name.text.isEmpty ? 'กรุณาใส่ชื่อคอลเลกชั่น' : null;
                      return;
                    });

                    if (_nameErrorMessage == null) {
                      App.getUseCase<ChordCollectionUseCase>(context, listen: false).add(_name.text);
                      _name = TextEditingController();
                      Navigator.pop(context);
                    }
                  },
                ),
                TextButton(
                  child: Text("ยกเลิก"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogCreateForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return TextField(
              controller: _name,
              autofocus: true,
              style: TextStyle(
                fontSize: 14.0,
              ),
              onChanged: (text) {
                if (_nameErrorMessage != null) {
                  setState(() {
                    _nameErrorMessage = null;
                  });
                }
              },
              decoration: InputDecoration(
                  errorText: _nameErrorMessage,
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  hintText: 'ชื่อคอลเลกชั่น'),
            );
          },
        )
      ],
    );
  }
}
