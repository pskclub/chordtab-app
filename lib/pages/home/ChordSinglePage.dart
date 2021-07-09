import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChordSinglePage extends StatefulWidget {
  final ChordTileItemModel chordModel;

  const ChordSinglePage({Key? key, required this.chordModel}) : super(key: key);

  @override
  _ChordSinglePageState createState() => _ChordSinglePageState(chordModel: chordModel);
}

class _ChordSinglePageState extends State<ChordSinglePage> {
  final ChordTileItemModel chordModel;

  _ChordSinglePageState({required this.chordModel});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Provider.of<ChordRepository>(context, listen: false).find(chordModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    var chord = Provider.of<ChordRepository>(context);
    return DefaultLayout(body: buildBody(chord), title: Text(chordModel.title));
  }

  buildBody(ChordRepository chord) {
    return chord.findStatus.isLoading || chord.findMeta == null
        ? Text("loading...")
        : SingleChildScrollView(
            child: Image.network(
              chord.findMeta!.image,
              fit: BoxFit.fitWidth,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          );
  }
}
