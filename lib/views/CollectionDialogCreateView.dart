import 'package:chordtab/constants/theme.const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionCreateDialogView extends StatelessWidget {
  const CollectionCreateDialogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          style: TextStyle(
            fontSize: 14.0,
          ),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              hintText: 'ชื่อคอลเลกชั่น'),
        )
      ],
    );
  }

  CollectionCreateDialogView.show(BuildContext context) {
    // set up the buttons
    Widget confirmButton = TextButton(
      child: Text(
        "เพิ่ม",
        style: TextStyle(color: ThemeColors.info),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("ยกเลิก"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: ThemeColors.primary,
      title: Text("เพิ่มคอลเลกชั่น",style: TextStyle(fontSize: 16),),
      content: CollectionCreateDialogView(),
      actions: [
        confirmButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
