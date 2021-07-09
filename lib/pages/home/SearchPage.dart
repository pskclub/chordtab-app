import 'package:chordtab/constants/bottom_navbar.dart';
import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/repositories/AppRepository.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool shouldPop = true;

  @override
  Widget build(BuildContext context) {
    ChordRepository chordRepo = Provider.of<ChordRepository>(context);
    AppRepository appRepo = Provider.of<AppRepository>(context);
    return WillPopScope(
        onWillPop: () async {
          print(BOTTOM_NAVBAR.Search.index);
          appRepo.changeTab(BOTTOM_NAVBAR.Home.index);
          return false;
        },
        child: DefaultLayout(
            body: buildFloatingSearchBar(chordRepo),
            bottomNavigationBar: BottomNavigationBarView()));
  }

  FloatingSearchBar buildFloatingSearchBar(ChordRepository chordRepo) {
    return FloatingSearchBar(
      margins: EdgeInsets.only(
          top: AppBar().preferredSize.height + 18, left: 8, right: 8),
      progress: chordRepo.searchStatus.isLoading,
      automaticallyImplyBackButton: false,
      transitionCurve: Curves.easeInOutCubic,
      transition: CircularFloatingSearchBarTransition(),
      physics: const BouncingScrollPhysics(),
      accentColor: COLOR_INFO,
      backdropColor: Colors.transparent,
      queryStyle: TextStyle(color: THEME.shade500),
      hintStyle: TextStyle(color: Colors.grey),
      backgroundColor: Colors.white,
      iconColor: Colors.grey,
      scrollPadding: EdgeInsets.zero,
      hint: 'Search...',
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        if (query.isNotEmpty) {
          chordRepo.search(query);
        }
      },
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ChordListView(
          items: chordRepo.searchMeta.items,
        );
      },
    );
  }
}
