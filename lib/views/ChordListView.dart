import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/pages/home/ChordSinglePage.dart';
import 'package:chordtab/views/ChordItemView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordListView extends StatelessWidget {
  final List<ChordTileItemModel> items;

  const ChordListView({Key? key, required this.items}) : super(key: key);

  ChordItemView _buildItemsForListView(BuildContext context, int index) {
    return ChordItemView(
      item: items[index],
      onItemClick: (item) {
        print(item.link);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChordSinglePage(chordModel: item)),
        );
      },
      onActionClick: (item) => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(parent: ClampingScrollPhysics()),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: _buildItemsForListView,
    );
  }
}
