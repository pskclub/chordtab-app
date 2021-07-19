import 'dart:async';

import 'package:chordtab/pages/CollectionPage.dart';
import 'package:chordtab/pages/FavoritePage.dart';
import 'package:chordtab/pages/HomePage.dart';
import 'package:chordtab/pages/SearchPage.dart';
import 'package:chordtab/usecases/AppUseCase.dart';
import 'package:chordtab/usecases/ChordCollectionUseCase.dart';
import 'package:chordtab/usecases/ChordFavoriteUseCase.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'constants/theme.const.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runZonedGuarded(() {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppUseCase()),
        ChangeNotifierProvider(create: (_) => ChordUseCase()),
        ChangeNotifierProvider(create: (_) => ChordFavoriteUseCase()),
        ChangeNotifierProvider(create: (_) => ChordCollectionUseCase()),
      ],
      child: MyApp(),
    ));
  }, FirebaseCrashlytics.instance.recordError);
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
    CollectionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    AppUseCase appRepo = Provider.of<AppUseCase>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChordTab',
      theme: ThemeData(
        fontFamily: "Prompt",
        backgroundColor: ThemeColors.primary,
        primaryColor: ThemeColors.primary,
        accentColor: ThemeColors.secondary,
        dialogBackgroundColor: ThemeColors.primary,
        splashColor: ThemeColors.primary,
        scaffoldBackgroundColor: ThemeColors.bg,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: _widgetOptions.elementAt(appRepo.tabIndex),
    );
  }
}
