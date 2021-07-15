import 'package:chordtab/core/App.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CollectionCreateDialog.dart';

class CollectionSheet extends StatefulWidget {
  final ChordItemModel chordModel;

  CollectionSheet({Key? key, required this.chordModel}) : super(key: key);

  @override
  _CollectionSheetState createState() => _CollectionSheetState(chordModel: chordModel);
}

class _CollectionSheetState extends State<CollectionSheet> {
  ChordItemModel chordModel;

  _CollectionSheetState({required this.chordModel});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      App.getUseCase<ChordCollectionUseCase>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    var collectionUseCase = App.getUseCase<ChordCollectionUseCase>(context);
    var list = collectionUseCase.fetchResult.items.map((value) {
      return ListTile(
        title: Text(value.name),
        onTap: () {
          App.getUseCase<ChordCollectionUseCase>(context, listen: false).addChord(value.id, chordModel);
          Navigator.pop(context);
        },
      );
    }).toList();

    list = [
      ListTile(
        leading: Icon(Icons.add),
        title: Text('สร้างคอลเลกชั่น'),
        onTap: () {
          collectionShowCreateDialog(context);
        },
      ),
      ...list
    ];
    return Column(mainAxisSize: MainAxisSize.min, children: list);
  }
}
