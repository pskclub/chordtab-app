import 'package:chordtab/pages/home/HomePage.dart';
import 'package:chordtab/pages/home/SearchPage.dart';
import 'package:chordtab/repositories/AppRepository.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppRepository()),
      ChangeNotifierProvider(create: (_) => ChordRepository()),
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
  Widget appBarTitle = new Text("ChordTab");
  Icon actionIcon = new Icon(Icons.search);

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    AppRepository appRepo = Provider.of<AppRepository>(context);

    return MaterialApp(
      title: 'ChordTab',
      theme: ThemeData(
        primaryColor: Color(0xff182245),
        scaffoldBackgroundColor: Color(0xFF171E3B),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: _widgetOptions.elementAt(appRepo.tabIndex),
    );
  }
}
