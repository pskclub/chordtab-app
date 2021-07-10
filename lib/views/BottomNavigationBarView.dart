import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/usecases/AppUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUseCase appRepo = Provider.of<AppUseCase>(context);
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'หน้าแรก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'ค้นหา',
        ),
      ],
      currentIndex: appRepo.tabIndex,
      selectedItemColor: COLOR_INFO,
      unselectedItemColor: Colors.white,
      backgroundColor: THEME.shade500,
      onTap: (index) => appRepo.changeTab(index),
    );
  }
}
