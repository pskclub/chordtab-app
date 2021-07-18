import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/models/ChordCollectionItemModel.dart';
import 'package:chordtab/pages/CollectionSinglePage.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CollectionItemView.dart';

class CollectionListView extends StatelessWidget {
  final List<ChordCollectionItemModel> items;
  final bool isItemRounded;

  const CollectionListView({Key? key, required this.items, this.isItemRounded = false}) : super(key: key);

  CollectionItemView _buildItemsForListView(BuildContext context, int index) {
    return CollectionItemView(
      item: items[index],
      onItemClick: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CollectionSinglePage(collectionModel: item)),
        );
      },
      onActionClick: (item) => {showAlertDialog(context, item)},
    );
  }

  showAlertDialog(BuildContext context, ChordCollectionItemModel item) {
    // set up the buttons
    Widget confirmButton = TextButton(
      child: Text(
        "ลบ",
        style: TextStyle(color: ThemeColors.secondary),
      ),
      onPressed: () {
        App.getUseCase<ChordCollectionUseCase>(context, listen: false).delete(item.id);
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("ยกเลิก"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: ThemeColors.primary,
      content: Text("ลบคอลเลกชั่น?"),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(parent: ClampingScrollPhysics()),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: _buildItemsForListView,
    );
  }
}
