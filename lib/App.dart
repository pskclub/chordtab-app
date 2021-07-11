import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class App {
  static Con getController<Con extends Controller>(BuildContext context,
      {bool listen = true}) {
    return   Provider.of<ChordUseCase>(context, listen: false)
  }
}