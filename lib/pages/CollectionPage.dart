import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/features/collection/ChordCollectionListView.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordListLoadingView.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      App.getUseCase<ChordCollectionUseCase>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        body: Consumer<ChordCollectionUseCase>(builder: (BuildContext context, collectionUseCase, Widget? child) {
          return _buildBody(collectionUseCase);
        }),
        title: Text("คอลเลกชั่น"),
        bottomNavigationBar: BottomNavigationBarView(),
        appBarActions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateDialog();
            },
          ),
        ]);
  }

  Widget _buildBody(ChordCollectionUseCase collectionUseCase) {
    return StatusWrapper(
        status: collectionUseCase.fetchResult,
        body: ChordCollectionListView(items: collectionUseCase.fetchResult.items),
        loading: ChordListLoadingView());
  }

  _showCreateDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                Navigator.pop(context);
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
  }

  Widget _buildDialogCreateForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          autofocus: true,
          style: TextStyle(
            fontSize: 14.0,
          ),
          decoration: InputDecoration(
              errorText: 'กรุณาใส่ชื่อคอลเลกชั่น',
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              hintText: 'ชื่อคอลเลกชั่น'),
        )
      ],
    );
  }
}
