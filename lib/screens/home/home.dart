import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imageprocessing/providers/blur_slider_provider.dart';
import 'package:imageprocessing/providers/image_engine_provider.dart';
import 'package:imageprocessing/utils/dimention_in_percent.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class HomePage extends StatelessWidget {
  ///for image name
  TextEditingController outputImageNameController = TextEditingController();

  ///full height and width
  double _screenHeight, _screenWidth;
  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        ///image engine provider
        ChangeNotifierProvider<ImageEngine>(
          builder: (context) => ImageEngine(),
        ),

        ///blur slider provider
        ChangeNotifierProvider<BlurSliderProvider>(
          builder: (context) => BlurSliderProvider(),
        )
      ],
      child: Builder(builder: (BuildContext context) {
        var _imageEngine = Provider.of<ImageEngine>(context);

        var _blurSliderProvider = Provider.of<BlurSliderProvider>(context);
        return Scaffold(
          appBar: PreferredSize(
            child: Container(
              height: 0,
            ),
            preferredSize: Size.zero,
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              ///pick button
              _pickButton(
                  screenHeight: _screenHeight,
                  screenWidth: _screenWidth,
                  provider: _imageEngine),

              ///display image portion
              _imageWindow(context,
                  provider: _imageEngine,
                  screenHeight: _screenHeight,
                  screenWidth: _screenWidth),

              ///for blur slider
              blurSlider(
                  blurProvider: _blurSliderProvider,
                  imageEngineProvider: _imageEngine,
                  screenHeight: _screenHeight,
                  screenWidth: _screenWidth)
            ],
          ),
        );
      }),
    );
  }

  ///returns image window where the image
  ///is to be shown
  Widget _imageWindow(BuildContext context,
      {@required screenHeight, @required screenWidth, @required provider}) {
    return Positioned(
        left: percent(screenWidth, 5),
        right: percent(screenWidth, 5),
        top: percent(screenHeight, 10),
        child: provider.getImage != null
            ? InkWell(
                onLongPress: () {
                  ///save current image
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          children: <Widget>[
                            ////text field
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: TextField(
                                controller: outputImageNameController,
                                decoration: InputDecoration(
                                  isDense: true,
                                ),
                              ),
                            ),

                            ///for save or cancel button
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  ///for cancel button
                                  CupertinoButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),

                                  ///for save button
                                  CupertinoButton(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      ///save image
                                      outputImageNameController.text != ''
                                          ? provider.setOutputImageName =
                                              outputImageNameController.text
                                          : 'outputImage';

                                      provider.saveImage();
                                      outputImageNameController.clear();
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      });
                },
                child: Container(
                  height: percent(screenWidth, 90),
                  width: percent(screenWidth, 90),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: provider.getImage, alignment: Alignment.center),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(1, 1),
                          color: Colors.grey)
                    ],
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ))
            : Text('Tap button below to pick image.'));
  }

  ///returns slider to change blur
  ///values of image
  Widget blurSlider(
      {@required blurProvider,
      @required imageEngineProvider,
      @required double screenHeight,
      @required double screenWidth}) {
    return Positioned(
      left: percent(screenWidth, 5),
      bottom: percent(screenHeight, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ///for slider type
          Text('Blur'),

          ///for slider
          Slider(
            activeColor: Colors.deepPurple[900],
            onChanged: (value) {
              blurProvider.setSliderValue = value;
              int kernelSize = (value + 1).round();
              imageEngineProvider.setKernelSize = kernelSize;
              imageEngineProvider.setImage = imageEngineProvider.imBlur();
            },
            divisions: 5,
            max: 10,
            onChangeEnd: (value) {
              print(value);
            },
            value: blurProvider.sliderValue,
          ),
        ],
      ),
    );
  }

  ///returns a button to pick an image
  Widget _pickButton(
      {@required double screenHeight,
      @required double screenWidth,
      @required var provider}) {
    return Positioned(
      bottom: 0,
      left: percent(screenWidth, 40),
      right: percent(screenWidth, 40),
      child: InkWell(
        highlightColor: Colors.grey,
        customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100), topRight: Radius.circular(100))),
        onTap: () {
          _imagePicker(provider).then((_) {
            provider.setKernelSize = 1;

            provider.setImage = provider.imLoad();
          });
        },
        child: Container(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            width: percent(screenWidth, 20),
            decoration: BoxDecoration(
                color: Colors.deepPurple[900],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100))),
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.add,
              // semanticLabel: 'Pick Image',
              size: 30,
              color: Colors.white,
            )),
      ),
    );
  }

  ///to pick an image from library or camera
  Future _imagePicker(var imageEngineProvider) async {
    var file = await FilePicker.getFile(type: FileType.ANY);
    String imagePath = file.path;
    imageEngineProvider.setImagePath = imagePath;
    imageEngineProvider.setImageDirectory = file.parent.path;
    return imagePath;
  }
}
