import 'package:chordtab/pages/home/HomePage.dart';
import 'package:chordtab/repositories/ChordRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ChordRepository()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChordTab',
      theme: ThemeData(
        primaryColor: Color(0xff182245),
        scaffoldBackgroundColor: Color(0xFF171E3B),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}
