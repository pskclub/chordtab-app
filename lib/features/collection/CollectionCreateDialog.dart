import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionCreateDialog extends StatefulWidget {
  const CollectionCreateDialog({Key? key}) : super(key: key);

  @override
  _CollectionCreateDialogState createState() => _CollectionCreateDialogState();
}

class _CollectionCreateDialogState extends State<CollectionCreateDialog> {
  TextEditingController _name = TextEditingController();
  String? _nameErrorMessage;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return TextField(
              controller: _name,
              autofocus: true,
              style: TextStyle(
                fontSize: 14.0,
              ),
              onChanged: (text) {
                if (_nameErrorMessage != null) {
                  setState(() {
                    _nameErrorMessage = null;
                  });
                }
              },
              decoration: InputDecoration(
                  errorText: _nameErrorMessage,
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  hintText: 'ชื่อคอลเลกชั่น'),
            );
          },
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "สร้าง",
                style: TextStyle(color: ThemeColors.info),
              ),
              onPressed: () {
                setState(() {
                  _nameErrorMessage = _name.text.isEmpty ? 'กรุณาใส่ชื่อคอลเลกชั่น' : null;
                  return;
                });

                if (_nameErrorMessage == null) {
                  App.getUseCase<ChordCollectionUseCase>(context, listen: false).add(_name.text);
                  _name = TextEditingController();
                  Navigator.pop(context);
                }
              },
            ),
            TextButton(
              child: Text("ยกเลิก"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}

void collectionShowCreateDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 16),
            backgroundColor: ThemeColors.primary,
            title: Text(
              "สร้างคอลเลกชั่น",
              style: TextStyle(fontSize: 16),
            ),
            content: CollectionCreateDialog(),
          );
        },
      );
    },
  );
}
