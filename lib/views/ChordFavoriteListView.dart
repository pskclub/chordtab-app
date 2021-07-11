import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/pages/home/ChordSinglePage.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:chordtab/views/ChordFavoriteItemView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordFavoriteListView extends StatelessWidget {
  final List<ChordItemModel> items;
  final bool isItemRounded;

  const ChordFavoriteListView({Key? key, required this.items, this.isItemRounded = false}) : super(key: key);

  ChordFavoriteItemView _buildItemsForListView(BuildContext context, int index) {
    return ChordFavoriteItemView(
      isRounded: isItemRounded,
      item: items[index],
      onItemClick: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChordSinglePage(chordModel: item)),
        );
      },
      onActionClick: (item) => {showAlertDialog(context, item)},
    );
  }

  showAlertDialog(BuildContext context, ChordItemModel item) {
    // set up the buttons
    Widget confirmButton = TextButton(
      child: Text(
        "ลบ",
        style: TextStyle(color: ThemeColors.info),
      ),
      onPressed: () {
        App.getUseCase<ChordFavoriteUseCase>(context, listen: false).delete(item.id);
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
      content: Text("ลบออกจากรายการโปรด?"),
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
