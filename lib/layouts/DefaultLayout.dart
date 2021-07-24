import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// class DefaultLayout extends StatefulWidget {
//   final Widget body;
//   final Widget? title;
//   final Widget? bottomNavigationBar;
//   final Widget? floatingActionButton;
//   final List<Widget>? appBarActions;
//
//   const DefaultLayout({
//     Key? key,
//     required this.body,
//     this.title,
//     this.bottomNavigationBar,
//     this.floatingActionButton,
//     this.appBarActions,
//   }) : super(key: key);
//
//   @override
//   _DefaultLayoutState createState() => _DefaultLayoutState(
//       body: body,
//       title: title,
//       bottomNavigationBar: bottomNavigationBar,
//       floatingActionButton: floatingActionButton,
//       appBarActions: appBarActions);
// }
//
// class _DefaultLayoutState extends State<DefaultLayout> {
//   Widget body;
//   Widget? title;
//   Widget? bottomNavigationBar;
//   Widget? floatingActionButton;
//   List<Widget>? appBarActions;
//
//   const _DefaultLayoutState({
//     required this.body,
//     this.title,
//     this.bottomNavigationBar,
//     this.floatingActionButton,
//     this.appBarActions,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class DefaultLayout extends StatelessWidget {
  final Widget body;
  final Widget? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final List<Widget>? appBarActions;
  final double? appBarElevation;

  const DefaultLayout({
    Key? key,
    required this.body,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.appBarActions,
    this.appBarElevation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(
              title: title,
              actions: appBarActions,
              elevation: appBarElevation,
              centerTitle: true,
            )
          : null,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
