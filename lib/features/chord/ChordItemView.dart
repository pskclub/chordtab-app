import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/pages/ChordSinglePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChordItemBottomSheet.dart';

class ChordItemView extends StatelessWidget {
  final ChordItemModel item;
  final bool isRounded;


  const ChordItemView({Key? key, required this.item,  this.isRounded = false})
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
            Icons.more_horiz,
          ),
          onPressed: () {
            ChordItemBottomSheet.build(context, item);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChordSinglePage(chordModel: item)),
          );
        });
  }
}
