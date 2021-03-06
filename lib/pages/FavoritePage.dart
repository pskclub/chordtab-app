import 'package:chordtab/constants/bottom_navbar.const.dart';
import 'package:chordtab/features/chord/ChordListLoadingView.dart';
import 'package:chordtab/features/favorite/ChordFavoriteListView.dart';
import 'package:chordtab/features/favorite/EmptyFavoriteView.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/AppUseCase.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return WillPopScope(
      onWillPop: () async {
        App.getUseCase<AppUseCase>(context, listen: false).changeTab(BOTTOM_NAVBAR.Home.index, context);
        return false;
      },
      child: DefaultLayout(
          body: Consumer<ChordFavoriteUseCase>(builder: (BuildContext context, favoriteUseCase, Widget? child) {
            return buildBody(favoriteUseCase);
          }),
          title: Text("รายการโปรด"),
          bottomNavigationBar: BottomNavigationBarView()),
    );
  }

  Widget buildBody(ChordFavoriteUseCase favoriteRepo) {
    return StatusWrapper(
        status: favoriteRepo.fetchResult,
        body: EmptyFavoriteView(
            isEmpty: favoriteRepo.fetchResult.items.isEmpty,
            child: ChordFavoriteListView(items: favoriteRepo.fetchResult.items)),
        loading: ChordListLoadingView());
  }
}
