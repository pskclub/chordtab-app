import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';

class EmptyCollectionView extends StatelessWidget {
  final Widget child;
  final bool isEmpty;

  const EmptyCollectionView({Key? key, required this.child, required this.isEmpty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isEmpty
        ? child
        : Center(
          child: Container(
            width: 200,
            child: EmptyWidget(
                title: 'คอลเลกชั่น',
                subTitle: 'คุณยังไม่มีคอลเลกชั่น',
                titleTextStyle: TextStyle(
                  fontSize: 22,
                  color: Color(0xff9da9c7),
                  fontWeight: FontWeight.w500,
                ),
                subtitleTextStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xffabb8d6),
                ),
              ),
          ),
        );
  }
}
