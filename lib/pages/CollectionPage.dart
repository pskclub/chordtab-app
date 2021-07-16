import 'package:chordtab/constants/bottom_navbar.const.dart';
import 'package:chordtab/features/chord/ChordListLoadingView.dart';
import 'package:chordtab/features/collection/CollectionCreateDialog.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      App.getUseCase<ChordCollectionUseCase>(context, listen: false).fetch();
    });
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
            IconButton(
                onPressed: () {
                  collectionShowCreateDialog(context);
                },
                icon: Icon(Icons.add))
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
}
