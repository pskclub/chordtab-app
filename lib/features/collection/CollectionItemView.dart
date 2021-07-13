import 'package:chordtab/models/ChordCollectionItemModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionItemView extends StatelessWidget {
  final ChordCollectionItemModel item;
  final bool isRounded;

  final void Function(ChordCollectionItemModel item)? onItemClick;
  final void Function(ChordCollectionItemModel item)? onActionClick;

  const CollectionItemView(
      {Key? key, required this.item, this.onItemClick, this.onActionClick, this.isRounded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: isRounded
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        title: Text(item.name),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
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
