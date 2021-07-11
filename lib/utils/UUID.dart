import 'package:uuid/uuid.dart';

class UUID {
  static String v4() {
    final uuid = Uuid();
    return uuid.v4();
  }
}
