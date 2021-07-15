import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddChordToCollectionForm.dart';

class ChordItemBottomSheet {
  static Column build(BuildContext context, ChordItemModel item) {
    var favoriteRepo = App.getUseCase<ChordFavoriteUseCase>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: new Icon(Icons.collections_bookmark),
          title: new Text('คอลเลกชั่น'),
          onTap: () {
            ChordItemBottomSheet._showAddChordToCollectionDialog(context, item);
            // Navigator.pop(context);
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
  }

  static _showAddChordToCollectionDialog(BuildContext context, ChordItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8),
          backgroundColor: ThemeColors.primary,
          title: Text(
            "เลือกคอลเลกชั่น",
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
