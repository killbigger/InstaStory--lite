import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:instastory/editImage.dart';
// import 'package:tapioca/tapioca.dart';
// import 'package:path_provider/path_provider.dart';

class EditVideo extends StatefulWidget {
  final File video;
  EditVideo({this.video});
  @override
  _EditVideoState createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  final scaf = GlobalKey<ScaffoldState>();
  List textList = [];
  String text;
  List<double> textSize = [];
  List<double> x = [];
  List<double> y = [];
  List textsss = [];
  List<Color> textColor = [];
  bool done = false;
  VideoPlayerController videoPlayerController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.video)
      ..initialize().then((_) {
        setState(() {
          videoPlayerController.play();
          videoPlayerController.setLooping(true);
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  tapiocaEditor() async {
    //   List tapiocaBalls = [];
    //   for (int i = 0; i < textsss.length; ++i) {
    //     tapiocaBalls.add(
    //       TapiocaBall.textOverlay(textList[i], x[i].toInt(), y[i].toInt(),
    //           textSize[i].toInt(), textColor[i]),
    //     );
    //   }
    //   // final tapiocaBalls = [
    //   //   TapiocaBall.textOverlay(textList[0], x[0].toInt(), y[0].toInt(),
    //   //       textSize[0].toInt(), textColor[0]),
    //   // ];
    //   var tempDir = await getTemporaryDirectory();
    //   final path = '${tempDir.path}/result.mp4';
    //   final cup = Cup(Content(widget.video.path), tapiocaBalls);
    //   cup.suckUp(path).then((_) {
    //     print("finish processing");
    //     Navigator.pop(context);
    //   }).catchError((onError) {
    //     print(onError.toString());
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaf,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.text_fields),
              color: Colors.white,
              onPressed: () async {
                text = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return TextForm();
                }));
                if (text.isNotEmpty) {
                  setState(() {
                    textsss.add(0);
                    textList.add(text);
                    textSize.add(20);
                    x.add(0);
                    y.add(0);
                    textColor.add(Colors.white);
                  });
                }
              }),
          IconButton(
              icon: Icon(Icons.clear),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  textsss.clear();
                  textList.clear();
                  textSize.clear();
                  x.clear();
                  y.clear();
                  textColor.clear();
                });
              }),
          IconButton(
            icon: Icon(Icons.done),
            color: Colors.white,
            onPressed: () {
              print('DONE');
              // tapiocaEditor();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          videoPlayerController.value.initialized
              ? AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                )
              : Container(),
          Stack(
              children: textsss.asMap().entries.map((e) {
            print(e.key);
            return Positioned(
              left: x[e.key],
              top: y[e.key],
              child: GestureDetector(
                onTap: () {
                  scaf.currentState.showBottomSheet((context) {
                    double size = textSize[e.key];
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            BlockPicker(
                              layoutBuilder: (BuildContext context,
                                  List<Color> colors, PickerItem child) {
                                return Container(
                                  width: 400,
                                  height: 100,
                                  child: GridView.count(
                                    crossAxisCount: 10,
                                    crossAxisSpacing: 1.0,
                                    mainAxisSpacing: 20.0,
                                    children: colors
                                        .map((Color color) => child(color))
                                        .toList(),
                                  ),
                                );
                              },
                              pickerColor: textColor[e.key],
                              onColorChanged: (c) {
                                setState(() {
                                  textColor[e.key] = c;
                                });
                              },
                            ),
                            Slider(
                              min: 5,
                              max: 65,
                              value: size,
                              onChanged: (v) {
                                setState(() {
                                  size = v;
                                  textSize[e.key] = v;
                                });
                              },
                            ),
                            RaisedButton(
                              child: const Text('Close BottomSheet'),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    x[e.key] = x[e.key] + details.delta.dx;
                    y[e.key] = y[e.key] + details.delta.dy;
                  });
                },
                child: Text(
                  textList[e.key],
                  style: TextStyle(
                      fontSize: textSize[e.key], color: textColor[e.key]),
                ),
              ),
            );
          }).toList())
        ],
      ),
    );
  }
}
