import 'package:chordtab/core/App.dart';
import 'package:chordtab/features/chord/ChordListLoadingView.dart';
import 'package:chordtab/features/collection/CollectionChordListView.dart';
import 'package:chordtab/features/collection/EmptyChordCollectionView.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/models/ChordCollectionItemModel.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CollectionSinglePage extends StatefulWidget {
  final ChordCollectionItemModel collectionModel;

  const CollectionSinglePage({Key? key, required this.collectionModel}) : super(key: key);

  @override
  _CollectionSinglePageState createState() => _CollectionSinglePageState(collectionModel: collectionModel);
}

class _CollectionSinglePageState extends State<CollectionSinglePage> {
  final ChordCollectionItemModel collectionModel;

  _CollectionSinglePageState({required this.collectionModel});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      App.getUseCase<ChordCollectionUseCase>(context, listen: false).fetchChords(collectionModel.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        body: Consumer<ChordCollectionUseCase>(builder: (BuildContext context, collectionUseCase, Widget? child) {
          return buildBody(collectionUseCase);
        }),
        title: Text("คอลเลกชั่น: ${collectionModel.name}"),
        bottomNavigationBar: BottomNavigationBarView());
  }

  Widget buildBody(ChordCollectionUseCase collectionUseCase) {
    return StatusWrapper(
        status: collectionUseCase.fetchChordsResult,
        body: EmptyChordCollectionView(
            isEmpty: collectionUseCase.fetchChordsResult.items.isEmpty,
            child: CollectionChordListView(items: collectionUseCase.fetchChordsResult.items)),
        loading: ChordListLoadingView());
  }
}
