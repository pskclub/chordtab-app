import 'package:chordtab/pages/home/FavoritePage.dart';
import 'package:chordtab/pages/home/HomePage.dart';
import 'package:chordtab/pages/home/SearchPage.dart';
import 'package:chordtab/usecases/AppUseCase.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/theme.const.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppUseCase()),
      ChangeNotifierProvider(create: (_) => ChordUseCase()),
      ChangeNotifierProvider(create: (_) => ChordFavoriteUseCase()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    FavoritePage(),
    FavoritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    AppUseCase appRepo = Provider.of<AppUseCase>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChordTab',
      theme: ThemeData(
        primaryColor: ThemeColors.primary,
        scaffoldBackgroundColor: ThemeColors.bg,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: _widgetOptions.elementAt(appRepo.tabIndex),
    );
  }
}
