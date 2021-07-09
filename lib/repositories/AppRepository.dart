import 'package:chordtab/constants/bottom_navbar.dart';
import 'package:flutter/cupertino.dart';

class AppRepository with ChangeNotifier {
  int tabIndex = BOTTOM_NAVBAR.Home.index;

  changeTab(int index) {
    tabIndex = index;
    notifyListeners();
  }
}
