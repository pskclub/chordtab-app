import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class App {
  static T getUseCase<T>(BuildContext context, {bool listen = true}) {
    return Provider.of<T>(context, listen: listen);
  }
}
