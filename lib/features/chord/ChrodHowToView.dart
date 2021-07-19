import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:chordtab/views/StatusWrapper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChordToView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Consumer<ChordUseCase>(
          builder: (BuildContext context, chordUseCase, Widget? child) {
            return StatusWrapper(
              status: chordUseCase.findResult,
              body: Wrap(
                alignment: WrapAlignment.center,
                children: chordUseCase.findResult.data!.chordImages.map((value) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExtendedImage.network(
                        value,
                        fit: BoxFit.fitWidth,
                        cache: true,
                      ));
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
