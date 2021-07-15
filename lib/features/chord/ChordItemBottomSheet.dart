import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/features/collection/CollectionCreateDialog.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddChordToCollectionForm.dart';

class CollectionSheet extends StatefulWidget {
  ChordItemModel chordModel;

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

class ChordItemBottomSheet {
  static Future<void> build(BuildContext context, ChordItemModel item, Function onCollectionSelect) {
    var favoriteRepo = App.getUseCase<ChordFavoriteUseCase>(context, listen: false);
    var _buildBottomSheet = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: new Icon(Icons.collections_bookmark),
          title: new Text('คอลเลกชั่น'),
          onTap: () {
            onCollectionSelect.call();
          },
        ),
        ListTile(
          leading: new Icon(Icons.favorite),
          title: new Text('รายการโปรด'),
          onTap: () {
            favoriteRepo.add(item);
            Navigator.pop(context);
          },
        ),
      ],
    );

    return showModalBottomSheet(
        backgroundColor: ThemeColors.primary,
        context: context,
        builder: (context) {
          return _buildBottomSheet;
        });
  }

  static buildSelectCollection(BuildContext context, ChordItemModel item) {
    showModalBottomSheet(
        backgroundColor: ThemeColors.primary,
        context: context,
        builder: (context) {
          return CollectionSheet(
            chordModel: item,
          );
        });
  }

  static _showAddChordToCollectionDialog(BuildContext context, ChordItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8),
          backgroundColor: ThemeColors.primary,
          title: Text(
            "สร้างคอลเลกชั่น",
            style: TextStyle(fontSize: 16),
          ),
          content: AddChordToCollectionForm(
            chordModel: item,
          ),
        );
      },
    );
  }
}
