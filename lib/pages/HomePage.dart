import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordListLoadingView.dart';
import 'package:chordtab/views/ChordListView.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/App.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String pageKey = 'home-1';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var chordRepo = App.getUseCase<ChordUseCase>(context, listen: false);
      if (!chordRepo.searchResult(pageKey).isLoaded) {
        chordRepo.search(pageKey, "bodyslam");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        body: Consumer<ChordUseCase>(builder: (BuildContext context, chordUseCase, Widget? child) {
          return _buildBody(chordUseCase);
        }),
        title: Text("Chord Tab"),
        bottomNavigationBar: BottomNavigationBarView());
  }

  Widget _buildBody(ChordUseCase chordUseCase) {
    return StatusWrapper(
        status: chordUseCase.searchResult(pageKey),
        body: ChordListView(items: chordUseCase.searchResult(pageKey).items),
        loading: ChordListLoadingView());
  }
}
