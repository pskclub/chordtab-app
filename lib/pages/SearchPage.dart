import 'package:chordtab/constants/bottom_navbar.const.dart';
import 'package:chordtab/constants/theme.const.dart';
import 'package:chordtab/layouts/DefaultLayout.dart';
import 'package:chordtab/usecases/AppUseCase.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:chordtab/views/BottomNavigationBarView.dart';
import 'package:chordtab/views/ChordListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';

import '../core/App.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = FloatingSearchBarController();
  final String pageKey = 'search';
  bool isShowList = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      controller.open();
    });
  }

  setShowListState(bool state) {
    setState(() {
      isShowList = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    ChordUseCase chordUseCase = App.getUseCase<ChordUseCase>(context);
    AppUseCase appRepo = Provider.of<AppUseCase>(context, listen: false);
    return WillPopScope(
        onWillPop: () async {
          appRepo.changeTab(BOTTOM_NAVBAR.Home.index);
          return false;
        },
        child: DefaultLayout(
            body: Consumer<ChordUseCase>(builder: (BuildContext context, chordUseCase, Widget? child) {
              return buildFloatingSearchBar(chordUseCase);
            }),
            bottomNavigationBar: BottomNavigationBarView()));
  }

  FloatingSearchBar buildFloatingSearchBar(ChordUseCase chordRepo) {
    return FloatingSearchBar(
        controller: controller,
        margins: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 16, right: 16),
        progress: chordRepo.searchResult(pageKey).isLoading,
        automaticallyImplyBackButton: false,
        transitionCurve: Curves.easeInOutCubic,
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        accentColor: ThemeColors.info,
        backdropColor: Colors.transparent,
        queryStyle: TextStyle(color: ThemeColors.primary),
        hintStyle: TextStyle(color: Colors.grey),
        backgroundColor: Colors.white,
        iconColor: Colors.grey,
        scrollPadding: EdgeInsets.zero,
        hint: 'ค้นหาคอร์ด...ชื่อเพลง, เนื้อเพลง, นักร้อง',
        debounceDelay: const Duration(milliseconds: 500),
        onQueryChanged: (query) {
          if (query.isNotEmpty) {
            chordRepo.search(pageKey, query);
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
        body: isShowList
            ? Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 80, left: 8, right: 8),
                child: ChordListView(
                  items: chordRepo.searchResult(pageKey).items,
                  isItemRounded: true,
                ),
              )
            : null,
        onFocusChanged: (isFocused) => isFocused ? setShowListState(false) : setShowListState(true),
        builder: (context, transition) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ChordListView(
              isItemRounded: true,
              items: chordRepo.searchResult(pageKey).items,
            ),
          );
        });
  }
}
