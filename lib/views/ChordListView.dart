import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/pages/home/ChordSinglePage.dart';
import 'package:chordtab/views/ChordItemView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordListView extends StatelessWidget {
  final List<ChordTileItemModel> items;
  final bool isItemRounded;

  const ChordListView({Key? key, required this.items, this.isItemRounded = false}) : super(key: key);

  ChordItemView _buildItemsForListView(BuildContext context, int index) {
    return ChordItemView(
      isRounded: isItemRounded,
      item: items[index],
      onItemClick: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChordSinglePage(chordModel: item)),
        );
      },
      onActionClick: (item) => {
        showModalBottomSheet(
            backgroundColor: THEME.shade500,
            context: context,
            builder: (context) {
              return buildBottomSheet(context);
            })
      },
    );
  }

  Column buildBottomSheet(BuildContext context) {
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
            Navigator.pop(context);
          },
        ),
      ],
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
