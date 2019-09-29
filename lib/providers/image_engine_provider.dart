import 'dart:typed_data';
import 'dart:io';
import 'package:dart_image_processing/dart_image_processing.dart';
import 'package:flutter/material.dart';
import 'package:imageprocessing/utils/to_one_d_list.dart';

class ImageEngine extends ChangeNotifier {
  /// the main appearing image
  MemoryImage image;

  ///current image path
  String imagePath;

  get getImage => image;
  get getImagePath => imagePath;

  set setImagePath(String imagePath) {
    this.imagePath = imagePath;
    notifyListeners();
  }

  set setImage(List<int> bytes) {
    U8Bitmap bitmapObj = U8Bitmap();
    bitmapObj.init(rawBytes: bytes);
    final readImage = bitmapObj.imread();
    SpatialFiltering filterObj = SpatialFiltering();
    var blurredImageBytes =
        filterObj.simpleFilter(image: readImage, kernelSize: 5);
    
    bitmapObj.imwrite(this.imagePath + 'newFile', blurredImageBytes);
    var newImageBytes = File(imagePath + 'newFile.bmp').readAsBytesSync();
    this.image = MemoryImage(newImageBytes);
    notifyListeners();
  }
}
