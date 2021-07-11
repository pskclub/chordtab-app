import 'package:chordtab/core/App.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordItemBottomSheet {
  static Column build(BuildContext context, ChordItemModel item) {
    var favoriteRepo = App.getUseCase<ChordFavoriteUseCase>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: new Icon(Icons.collections),
          title: new Text('คอลเลกชั่น'),
          onTap: () {
            Navigator.pop(context);
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
}
