import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordListLoadingView.dart';
import 'package:chordtab/views/ChordListView.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      var chordRepo = Provider.of<ChordUseCase>(context, listen: false);
      if (!chordRepo.getSearchResult(pageKey).isLoaded) {
        Provider.of<ChordUseCase>(context, listen: false).search(pageKey, "bodyslam");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ChordUseCase chordRepo = Provider.of<ChordUseCase>(context);
    return DefaultLayout(
        body: buildBody(chordRepo), title: Text("Chord Tab"), bottomNavigationBar: BottomNavigationBarView());
  }

  buildBody(ChordUseCase chordRepo) {
    return StatusWrapper(
        status: chordRepo.getSearchResult(pageKey),
        body: ChordListView(items: chordRepo.getSearchResult(pageKey).items),
        loading: ChordListLoadingView());
  }
}
