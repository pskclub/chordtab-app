import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddChordToCollectionForm extends StatefulWidget {
  final ChordItemModel chordModel;

  const AddChordToCollectionForm({Key? key, required this.chordModel}) : super(key: key);

  @override
  _AddChordToCollectionFormState createState() => _AddChordToCollectionFormState(chordModel: chordModel);
}

class _AddChordToCollectionFormState extends State<AddChordToCollectionForm> {
  final ChordItemModel chordModel;
  String? collectionId;
  String? _nameErrorMessage;

  _AddChordToCollectionFormState({required this.chordModel});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      App.getUseCase<ChordCollectionUseCase>(context, listen: false).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<ChordCollectionUseCase>(builder: (BuildContext context, collectionUseCase, Widget? child) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              errorText: _nameErrorMessage,
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              prefixIcon: Icon(Icons.collections_bookmark),
              hintText: 'เลือกคอลเลกชั่น',
              filled: true,
              fillColor: ThemeColors.primary,
            ),
            autofocus: true,
            value: collectionId,
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                collectionId = newValue!;
                if (_nameErrorMessage != null) {
                  _nameErrorMessage = null;
                }
              });
            },
            items: collectionUseCase.fetchResult.items.map((value) {
              return DropdownMenuItem(
                value: value.id,
                child: Text(value.name),
              );
            }).toList(),
          );
        }),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text(
                "เพิ่ม",
                style: TextStyle(color: ThemeColors.info),
              ),
              onPressed: () {
                setState(() {
                  if (collectionId == null || collectionId!.isEmpty) _nameErrorMessage = 'กรุณาใส่ชื่อคอลเลกชั่น';
                  return;
                });

                if (_nameErrorMessage == null) {
                  App.getUseCase<ChordCollectionUseCase>(context, listen: false).addChord(collectionId!, chordModel);
                  collectionId = null;
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
