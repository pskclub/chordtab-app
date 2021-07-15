import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/features/collection/CollectionBottomSheet.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordItemBottomSheet {
  static Future<void> build(BuildContext context, ChordItemModel item, Function onCollectionSelect) {
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
            App.getUseCase<ChordFavoriteUseCase>(context, listen: false).add(item);
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
}
