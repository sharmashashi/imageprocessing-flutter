import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:imageprocessing/providers/image_engine_provider.dart';
import 'package:imageprocessing/utils/dimention_in_percent.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class HomePage extends StatelessWidget {
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
        )
      ],
      child: Builder(builder: (BuildContext context) {
        var _imageEngine = Provider.of<ImageEngine>(context);
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
              _imageWindow(
                  provider: _imageEngine,
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
  Widget _imageWindow(
      {@required screenHeight, @required screenWidth, @required provider}) {
    return Positioned(
        left: percent(screenWidth, 5),
        right: percent(screenWidth, 5),
        top: percent(screenHeight, 10),
        child: provider.getImage != null
            ? Container(
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
              )
            : Text('Tap button below to pick image.'));
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
          _imagePicker(provider: provider).then((bytes) {
            provider.setImage = bytes;
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
  Future _imagePicker({@required provider}) async {
    // File unusedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    // String imagePath = '/storage/emulated/0/girl.bmp';
    var file = await FilePicker.getFile(type: FileType.ANY);
    String imagePath = file.parent.path+'/';
    String tempImagePath = file.path;
    // print('\n\n\n.................$imagePath.................\n\n');
    provider.setImagePath = imagePath;
    return file == null
        ? 'Image was not picked'
        : File(tempImagePath).readAsBytesSync().toList();
  }
}
