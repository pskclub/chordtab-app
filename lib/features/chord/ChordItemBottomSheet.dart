import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/core/App.dart';
import 'package:chordtab/features/collection/CollectionBottomSheet.dart';
import 'package:chordtab/models/ChordItemModel.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ChordItemBottomSheet {
  static Future<void> build(BuildContext context, ChordItemModel item, Function onCollectionSelect) {
    void _launchURL() async =>
        await canLaunch(item.link) ? await launch(item.link) : throw 'Could not launch ${item.link}';

    var _buildBottomSheet = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: new Icon(Icons.collections_bookmark),
          title: new Text('คอลเลกชั่น'),
          onTap: () {
            onCollectionSelect.call();
          },
        ),
        ListTile(
          leading: new Icon(Icons.favorite),
          title: new Text('รายการโปรด'),
          onTap: () {
            App.getUseCase<ChordFavoriteUseCase>(context, listen: false).add(item);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: new Icon(Icons.share),
          title: new Text('แชร์คอร์ดให้เพื่อน'),
          onTap: () {
            Share.share('ดูคอร์ดเพลง ${item.title} ได้ที่ ${item.link} \nจากแอพ ChordTab');
          },
        ),
        ListTile(
          leading: new Icon(Icons.public),
          title: new Text(
            'ไปที่ ${item.link}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: _launchURL,
        ),
      ],
    );

    return showModalBottomSheet(
        backgroundColor: ThemeColors.primary,
        context: context,
        builder: (context) {
          return _buildBottomSheet;
        });
  }

  static buildSelectCollection(BuildContext context, ChordItemModel item) {
    showModalBottomSheet(
        backgroundColor: ThemeColors.primary,
        context: context,
        builder: (context) {
          return CollectionSheet(
            chordModel: item,
          );
        });
  }
}
