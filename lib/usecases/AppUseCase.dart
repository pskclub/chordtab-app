import 'package:chordtab/constants/bottom_navbar.const.dart';
import 'package:flutter/cupertino.dart';

class AppUseCase with ChangeNotifier {
  int tabIndex = BOTTOM_NAVBAR.Home.index;

  changeTab(int index) {
    tabIndex = index;
    notifyListeners();
  }
}
