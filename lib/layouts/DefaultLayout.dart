import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget body;
  final Widget? title;
  final Widget? bottomNavigationBar;
  final List<Widget>? appBarActions;

  const DefaultLayout({
    Key? key,
    required this.body,
    this.title,
    this.bottomNavigationBar,
    this.appBarActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: title,
              actions: appBarActions,
            )
          : null,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
