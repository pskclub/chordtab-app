
import 'package:chordtab/models/ChordTileItemModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordItemView extends StatelessWidget {
  final ChordTileItemModel item;
  final void Function(ChordTileItemModel item)? onItemClick;
  final void Function(ChordTileItemModel item)? onActionClick;

  const ChordItemView({Key? key, required this.item, this.onItemClick, this.onActionClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        title: Text(item.title),
        subtitle: Text(item.description ?? "", style: TextStyle(fontSize: 12)),
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(item.cover),
              fit: BoxFit.cover,
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.more_horiz,
          ),
          onPressed: () {
            onActionClick?.call(item);
          },
        ),
        onTap: () {
          onItemClick?.call(item);
        });
  }
}
