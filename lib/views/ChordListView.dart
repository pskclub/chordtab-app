import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:chordtab/views/ChordItemView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordListView extends StatelessWidget {
  final List<ChordTileItemModel> items;
  final void Function(ChordTileItemModel item)? onClick;
  final void Function(ChordTileItemModel item)? onActionClick;

  const ChordListView(
      {Key? key, required this.items, this.onClick, this.onActionClick})
      : super(key: key);

  ChordItemView _buildItemsForListView(BuildContext context, int index) {
    return ChordItemView(
      item: items[index],
      onItemClick: onClick,
      onActionClick: onActionClick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: _buildItemsForListView,
    );
  }
}
