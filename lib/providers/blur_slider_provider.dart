import 'package:flutter/foundation.dart';

class BlurSliderProvider with ChangeNotifier {
  int _kernelSize = 1;
  double _sliderValue = 0.0;

  get kernelSize => _kernelSize;
  get sliderValue => _sliderValue;

  set setSliderValue(double value) {
    
    this._sliderValue = value;
    notifyListeners();
  }

  set setKernelSize(int size) {
    this._kernelSize = size;
    notifyListeners();
  }
}
