import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:extended_image/extended_image.dart';
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
      Provider.of<ChordUseCase>(context, listen: false).find(chordModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    var chord = Provider.of<ChordUseCase>(context);
    return DefaultLayout(body: buildBody(chord), title: Text(chordModel.title));
  }

  buildBody(ChordUseCase chord) {
    return chord.findStatus.isLoading
        ? Text("loading...")
        : SingleChildScrollView(
            child: ExtendedImage.network(
            chord.findMeta!.image,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            cache: false,
            loadStateChanged: buildLoadState,
          ));
  }

  Widget? buildLoadState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        return Text("loading...");

      case LoadState.completed:
        // TODO: Handle this case.
        break;
      case LoadState.failed:
        // TODO: Handle this case.
        break;
    }
  }
}
