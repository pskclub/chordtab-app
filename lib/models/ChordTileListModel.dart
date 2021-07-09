import 'package:chordtab/models/ChordTileItemModel.dart';

import 'BasePageModel.dart';

class ChordTileListModel extends BasePageModel<ChordTileItemModel> {
  ChordTileListModel(limit, page, total, items)
      : super(limit, page, total, items);

  factory ChordTileListModel.init() {
    return ChordTileListModel(0, 1, 0, List<ChordTileItemModel>.empty());
  }
}
