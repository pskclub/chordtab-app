import 'package:chordtab/features/favorite/ChordFavoriteListView.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordListLoadingView.dart';
import 'package:chordtab/views/EmptyView.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/App.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePage createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
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
        body: buildBody(favoriteRepo), title: Text("รายการโปรด"), bottomNavigationBar: BottomNavigationBarView());
  }

  buildBody(ChordFavoriteUseCase favoriteRepo) {
    return StatusWrapper(
        status: favoriteRepo.fetchResult,
        body: EmptyView(
            isEmpty: favoriteRepo.fetchResult.items.isEmpty,
            child: ChordFavoriteListView(items: favoriteRepo.fetchResult.items)),
        loading: ChordListLoadingView());
  }
}
