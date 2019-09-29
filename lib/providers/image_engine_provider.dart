import 'dart:typed_data';
import 'dart:io';
import 'package:dart_image_processing/dart_image_processing.dart';
import 'package:flutter/material.dart';
import 'package:imageprocessing/utils/merge_list.dart';
import 'package:imageprocessing/utils/to_one_d_list.dart';

class ImageEngine extends ChangeNotifier {
  /// the main appearing image
  MemoryImage image;

  ///kernel size
  int kernelSize;

  ///imagepath in device
  String imagePath;
  String imageDirectory;

  ///image header bytes
  List<int> _headerBytes;

  ///image raw bytes
  List<List<int>> _rawBytes;

  ///for U8Bitmap object
  var coreObject;

  ///for original image in 2d
  List<List<int>> originalImagePixels;

  ///output image name
  String outputImageName;

  get getImage => image;
  get getOriginalImagePixels => originalImagePixels;

  set setImageDirectory(String dir) {
    this.imageDirectory = dir;
  }

  set setOutputImageName(String imageName) {
    this.outputImageName = imageName;
  }

  set setImagePath(String path) {
    this.imagePath = path;
    notifyListeners();
  }

  set setKernelSize(int size) {
    this.kernelSize = size;
    notifyListeners();
  }

  set setImage(Uint8List bytes) {
    this.image = MemoryImage(bytes);
    notifyListeners();
  }

  ///loads image initially just after pickup
  Uint8List imLoad() {
    U8Bitmap bitmapObj = U8Bitmap(imagePath);

    coreObject = bitmapObj;
    originalImagePixels = bitmapObj.imread();
    this._headerBytes = bitmapObj.headerBytes;

    Uint8List returnImage = Uint8List.fromList(merge(
        first: _headerBytes, second: toOneDList(srcList: originalImagePixels)));
    return returnImage;
  }

  ///calculates blur image bytes with
  ///header and ra bytes in Uint8List
  Uint8List imBlur() {
    //List<List<int>> type

    SpatialFiltering spatialFiltering = SpatialFiltering();

    List<List<int>> filteredImage = spatialFiltering.simpleFilter(
        image: originalImagePixels, kernelSize: kernelSize);
    List<int> oneDList = toOneDList(srcList: filteredImage);

    ///to save image later
    _rawBytes = filteredImage;
    Uint8List returnImage =
        Uint8List.fromList(merge(first: _headerBytes, second: oneDList));
    return returnImage;
  }

  ///to save image in external storage
  ///with current image path
  saveImage() {
    coreObject.imwrite(imageDirectory + '/$outputImageName', _rawBytes);
  }
}
