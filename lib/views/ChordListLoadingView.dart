import 'package:chordtab/views/skeleton_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChordListLoadingView extends StatelessWidget {
  const ChordListLoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            SkeletonContainer.circular(
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SkeletonContainer.rounded(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 16,
                ),
                const SizedBox(height: 8),
                SkeletonContainer.rounded(
                  width: 60,
                  height: 13,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
