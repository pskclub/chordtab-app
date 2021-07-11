import 'package:chordtab/models/ChordItemModel.dart';

import 'BasePageModel.dart';

class ChordListModel extends BasePageModel<ChordItemModel> {
  ChordListModel(limit, page, total, items)
      : super(limit, page, total, items);

  factory ChordListModel.init() {
    return ChordListModel(0, 1, 0, List<ChordItemModel>.empty());
  }
}
