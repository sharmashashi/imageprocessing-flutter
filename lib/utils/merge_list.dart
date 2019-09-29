import 'package:meta/meta.dart';

List<int> merge({@required List<int> first, @required List<int> second}) {
  List<int> tempList = List<int>();
  for (int i = 0; i < first.length; i++) {
    tempList.add(first[i]);
  }
  for (int i = 0; i < second.length; i++) {
    tempList.add(second[i]);
  }
  return tempList;
}
