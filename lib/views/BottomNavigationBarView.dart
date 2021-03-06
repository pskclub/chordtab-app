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
          backgroundColor: ThemeColors.primary,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'ค้นหา',
          backgroundColor: ThemeColors.primary,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'รายการโปรด',
          backgroundColor: ThemeColors.primary,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.collections_bookmark),
          label: 'คอลเลกชั่น',
          backgroundColor: ThemeColors.primary,
        ),
      ],
      currentIndex: appRepo.tabIndex,
      selectedItemColor: ThemeColors.secondary,
      unselectedItemColor: Colors.white,
      backgroundColor: ThemeColors.primary,
      onTap: (index) => appRepo.changeTab(index,context),
    );
  }
}
