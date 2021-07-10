import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/ChordUsecase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordListView.dart';
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
      if (!chordRepo.getSearchStatus(pageKey).isLoaded) {
        Provider.of<ChordUseCase>(context, listen: false).search(pageKey, "รักแรกพบ");
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
    return chordRepo.getSearchStatus(pageKey).isLoading
        ? Text("loading.....")
        : ChordListView(
            items: chordRepo.getSearchItems(pageKey),
          );
  }
}
