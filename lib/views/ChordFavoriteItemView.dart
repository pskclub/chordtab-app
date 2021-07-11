import 'package:chordtab/models/ChordItemModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordFavoriteItemView extends StatelessWidget {
  final ChordItemModel item;
  final bool isRounded;

  final void Function(ChordItemModel item)? onItemClick;
  final void Function(ChordItemModel item)? onActionClick;

  const ChordFavoriteItemView({Key? key, required this.item, this.onItemClick, this.onActionClick, this.isRounded = false})
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
        title: Text(item.title),
        subtitle: Text(item.description ?? "", style: TextStyle(fontSize: 12)),
        leading: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(item.cover),
              fit: BoxFit.cover,
            ),
          ),
        ),
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
