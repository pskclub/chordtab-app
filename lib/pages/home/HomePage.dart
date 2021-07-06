import 'package:chordtab/repositories/ChordRepository.dart';
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
      Provider.of<ChordRepository>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    ChordRepository chordRepo = Provider.of<ChordRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chord Tab'),
      ),
      body: chordRepo.fetchStatus.isLoading
          ? Text("loading.....")
          : ChordListView(
              items: chordRepo.meta.items,
              onClick: (item) {
                print("item : ${item.title}");
                chordRepo.fetch();
              },
              onActionClick: (item) {
                print("action : ${item.title}");
              },
            ),
    );
  }
}
