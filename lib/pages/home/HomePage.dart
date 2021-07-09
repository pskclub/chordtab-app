import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/pages/home/ChordSinglePage.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      var chordRepo = Provider.of<ChordRepository>(context, listen: false);
      if (!chordRepo.searchStatus.isLoaded) {
        Provider.of<ChordRepository>(context, listen: false).search("รักแรกพบ");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ChordRepository chordRepo = Provider.of<ChordRepository>(context);
    return DefaultLayout(
        body: buildBody(chordRepo), title: Text("Chord Tab"), bottomNavigationBar: BottomNavigationBarView());
  }

  buildBody(ChordRepository chordRepo) {
    return chordRepo.searchStatus.isLoading
        ? Text("loading.....")
        : ChordListView(
            items: chordRepo.searchMeta.items,
          );
  }
}
