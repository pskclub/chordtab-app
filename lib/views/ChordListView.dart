import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/pages/home/ChordSinglePage.dart';
import 'package:chordtab/views/ChordItemBottomSheet.dart';
import 'package:chordtab/views/ChordItemView.dart';
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
      onItemClick: (item) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChordSinglePage(chordModel: item)),
        );
      },
      onActionClick: (item) => {
        showModalBottomSheet(
            backgroundColor: ThemeColors.primary,
            context: context,
            builder: (context) {
              return ChordItemBottomSheet.build(context);
            })
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
