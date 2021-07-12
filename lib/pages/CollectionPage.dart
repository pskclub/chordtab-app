import 'package:chordtab/features/collection/ChordCollectionListView.dart';
import 'package:chordtab/features/collection/CollectionDialogCreateView.dart';
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
          return buildBody(collectionUseCase);
        }),
        title: Text("คอลเลกชั่น"),
        bottomNavigationBar: BottomNavigationBarView(),
        appBarActions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              CollectionCreateDialogView.show(context);
            },
          ),
        ]);
  }

  Widget buildBody(ChordCollectionUseCase collectionUseCase) {
    return StatusWrapper(
        status: collectionUseCase.fetchResult,
        body: ChordCollectionListView(items: collectionUseCase.fetchResult.items),
        loading: ChordListLoadingView());
  }
}
