import 'package:flutter/foundation.dart';

class Utils {
  static void printLog(dynamic tag, String statement) {
    if (kDebugMode) {
      print("$tag $statement");
    }
  }

  static int getNextMultiple(int number) {
    int a = number % 100;

    if (a > 0) {
      return (number ~/ 100) * 100 + 100;
    }

    return number;
  }
}
