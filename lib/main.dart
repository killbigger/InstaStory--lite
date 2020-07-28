import 'dart:io';
import 'package:instastory/editVideo.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instastory/editImage.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading;
  double mHeight;
  double mWidth;

  File video;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    setState(() {
      loading = false;
    });
  }

  getImage(context) async {
    setState(() {
      loading = true;
    });
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    File image = File(pickedFile.path);

    if (image != null) {
      var fileName = basename(image.path);
      var decodeImage = imageLib.decodeImage(image.readAsBytesSync());
      decodeImage = imageLib.copyResize(decodeImage, width: 600);
      setState(() {
        loading = false;
      });
      Map imageFile = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new PhotoFilterSelector(
            title: Text("Select your Filter"),
            image: decodeImage,
            filename: fileName,
            filters: presetFiltersList,
            loader: Center(child: CircularProgressIndicator()),
            fit: BoxFit.contain,
          ),
        ),
      );
      if (imageFile.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EditImage(image: imageFile['image_filtered'])));
      }
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  getVideo(BuildContext context) async {
    setState(() {
      loading = true;
    });
    final pickedFile = await picker.getVideo(
        source: ImageSource.camera, maxDuration: Duration(minutes: 1));

    setState(() {
      video = File(pickedFile.path);
    });
    if (video != null) {
      setState(() {
        loading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditVideo(
                    video: video,
                  )));
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  loadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        'Loading.....',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    return loading
        ? loadingScreen()
        : Scaffold(
            body: Container(
                child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        height: mHeight * 0.5,
                      ),
                      Text(
                        'InstaStory',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      SizedBox(
                        height: mHeight / 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            ClipOval(
                              child: Material(
                                color: Colors.white, // button color
                                child: InkWell(
                                  splashColor: Colors.red, // inkwell color
                                  child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 30,
                                        color: Colors.black,
                                      )),
                                  onTap: () => getImage(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: mHeight * 0.5,
                      ),
                      Text(
                        'Lite',
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                      SizedBox(
                        height: mHeight / 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: <Widget>[
                            ClipOval(
                              child: Material(
                                color: Colors.black, // button color
                                child: InkWell(
                                  splashColor: Colors.red, // inkwell color
                                  child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: Icon(
                                        Icons.videocam,
                                        size: 30,
                                        color: Colors.white,
                                      )),
                                  onTap: () {
                                    getVideo(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )));
  }
}
