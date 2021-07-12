import 'package:chordtab/models/ChordCollectionItemModel.dart';
import 'package:flutter/cupertino.dart';

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
  Widget build(BuildContext context) {
    return Container();
  }
}
