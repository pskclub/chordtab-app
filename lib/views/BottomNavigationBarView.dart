import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/repositories/AppRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppRepository appRepo = Provider.of<AppRepository>(context);
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
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
