import 'package:flutter/foundation.dart';

List<int> toOneDList({@required List<List<int>> srcList}) {
  List<int> oneDList = List();
  for (int i = srcList.length-1; i >=0; i--) {
    for (int j = 0; j < srcList[0].length; j++) {
      oneDList.add(srcList[i][j]);
    }
  }
  return oneDList;
}
