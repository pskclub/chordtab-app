import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;
  final Widget? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    Key? key,
    required this.body,
    this.title,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: title != null ? AppBar(title: title) : null, bottomNavigationBar: bottomNavigationBar, body: body);
  }
}
