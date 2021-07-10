import 'package:chordtab/pages/home/HomePage.dart';
import 'package:chordtab/pages/home/SearchPage.dart';
import 'package:chordtab/usecases/AppUseCase.dart';
import 'package:chordtab/usecases/ChordUseCase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppUseCase()),
      ChangeNotifierProvider(create: (_) => ChordUseCase()),
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
    AppUseCase appRepo = Provider.of<AppUseCase>(context);

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
