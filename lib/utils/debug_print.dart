import 'package:flutter/foundation.dart';

void debugPrint(String str) {
  if(kDebugMode) {
    print(str);
  }
}