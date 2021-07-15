import 'package:chordtab/features/chord/ChordItemBottomSheet.dart';
import 'package:chordtab/features/chord/ChordItemView.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/pages/ChordSinglePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordListView extends StatelessWidget {
  final List<ChordItemModel> items;
  final bool isItemRounded;

  const ChordListView({Key? key, required this.items, this.isItemRounded = false}) : super(key: key);

  ChordItemView _buildItemsForListView(BuildContext context, int index) {
    return ChordItemView(
      isRounded: isItemRounded,
      item: items[index],
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
