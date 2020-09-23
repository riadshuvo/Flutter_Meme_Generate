import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey globalKey = new GlobalKey();
  Random rng = new Random();

  String headerText = "";
  String footerText = "";
  bool imageSelected = false;

  File _image, _imageFile;

  Future getImage(ImageSource source) async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: source);
    } catch (platformException) {
      print("not allowing " + platformException);
    }
    setState(() {
      if (image != null) {
        imageSelected = true;
      } else {}
      _image = image;
    });

    new Directory('storage/emulated/0/' + 'MemeGenerator')
        .create(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/fb.png",
                  height: 70,
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "MEME GENERATOR",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 14,
                ),
                memeStackContainer(),
                SizedBox(
                  height: 20,
                ),
                imageSelected
                    ? memeWritingArea()
                    : Container(
                        child: Center(
                          child: Text("Select image to get started"),
                        ),
                      ),
                _imageFile != null
                    ? Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.file(
                          _imageFile,
                          fit: BoxFit.fill,
                        ))
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.white30,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        child: Icon(Icons.add),
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        curve: Curves.bounceIn,
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera_alt, color: Colors.white),
            backgroundColor: Colors.red,
            onTap: () => getImage(ImageSource.camera),
            label: 'Camera',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15),
            labelBackgroundColor: Colors.redAccent,
          ),
          SpeedDialChild(
            child: Icon(Icons.photo_library, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () => getImage(ImageSource.gallery),
            label: 'Gallery',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.white, fontSize: 15),
            labelBackgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }


  Widget memeStackContainer() {
    return RepaintBoundary(
      key: globalKey,
      child: Stack(
        children: <Widget>[
          _image != null
              ? Container(
            margin: EdgeInsets.all(7),
            height: 300,
            width: double.infinity,
            child: Image.file(
              _image,
              fit: BoxFit.cover,
            ),
          )
              : Container(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    headerText.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black87,
                        ),
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 8.0,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      footerText.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black87,
                          ),
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 8.0,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget memeWritingArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (val) {
              setState(() {
                headerText = val;
              });
            },
            decoration: InputDecoration(hintText: "Header Text"),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            onChanged: (val) {
              setState(() {
                footerText = val;
              });
            },
            decoration: InputDecoration(hintText: "Footer Text"),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              RaisedButton(
                onPressed: () {
                  //TODO
                  takeScreenshot();
                },
                child: Text("Save"),
              ),
              SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  RaisedButton(
                    onPressed: () {
                      _shareImage();
                    },
                    child: Text("Share"),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  takeScreenshot() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 2);
    final directory = (await getApplicationDocumentsDirectory()).path;
    String fileName = DateTime.now().toIso8601String();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print("pngBytes: $pngBytes");
    final imgFile = new File('$directory/$fileName.png');

    _saveToGallery(imgFile, pngBytes);
  }

  void _saveToGallery(File imgFile, Uint8List pngBytes) {
    imgFile.writeAsBytes(pngBytes).then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          print("'Take photo'");
        });
        setState(() {
          _imageFile = recordedImage;
        });
        GallerySaver.saveImage(recordedImage.path, albumName: "Meme")
            .then((bool success) {
          setState(() {
            print("Image saved");
          });
          Future.delayed(Duration(seconds: 2)).then((_) {
            setState(() {
              print("'Take photo'");
            });
          });
        });
      }
    });

    _savefile(_imageFile);
  }

  _savefile(File file) async {
    await _askPermission();
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(await file.readAsBytes()));
    print(result);
  }

  _askPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.photos]);
  }

  void _shareImage() async {
    print("imagePath: ${_imageFile.path}");
    final RenderBox box = context.findRenderObject();
    Share.shareFiles(['${_imageFile.path}'],
        subject: 'Funny Meme',
        text: 'Hey, check it out the Meme',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

}
