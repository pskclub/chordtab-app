import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordFavoriteListView.dart';
import 'package:chordtab/views/ChordListLoadingView.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/App.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({Key? key}) : super(key: key);

  @override
  _FavoritePage createState() => _FavoritePage();
}

class _FavoritePage extends State<CollectionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var favoriteRepo = App.getUseCase<ChordFavoriteUseCase>(context, listen: false);
      favoriteRepo.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    ChordFavoriteUseCase favoriteRepo = App.getUseCase<ChordFavoriteUseCase>(context);
    return DefaultLayout(
        body: buildBody(favoriteRepo),
        title: Text("คอลเลกชั่น"),
        bottomNavigationBar: BottomNavigationBarView(),
        appBarActions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {

            },
          ),
        ]);
  }

  buildBody(ChordFavoriteUseCase favoriteRepo) {
    return StatusWrapper(
        status: favoriteRepo.fetchResult,
        body: ChordFavoriteListView(items: favoriteRepo.fetchResult.items),
        loading: ChordListLoadingView());
  }
}
