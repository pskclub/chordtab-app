import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordItemBottomSheet {
  static Column build(BuildContext context) {
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
}