import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditImage extends StatefulWidget {
  final File image;
  EditImage({this.image});
  @override
  _EditImageState createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  List textList = [];
  String text;
  List<double> x = [];
  List<double> y = [];
  List textsss = [];
  List<double> textSize = [];
  List<Color> textColor = [];
  bool done = false;
  bool slider = false;
  int key;
  ScreenshotController screenshotController = ScreenshotController();

  editor() {
    return Scaffold(
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
              File _imageFile;
              _imageFile = null;
              screenshotController
                  .capture(delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                  .then((File image) async {
                print("Capture Done");
                setState(() {
                  _imageFile = image;
                });
                final paths = await getExternalStorageDirectory();
                await image.copy(paths.path +
                    '/' +
                    DateTime.now().millisecondsSinceEpoch.toString() +
                    '.png');
                setState(() {
                  done = true;
                });
              }).catchError((onError) {
                print(onError);
                setState(() {
                  done = true;
                });
              });
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Image.file(
                widget.image,
                fit: BoxFit.fill,
              ),
            ),
            Stack(
                children: textsss.asMap().entries.map((e) {
              print(e.key);
              return Positioned(
                left: x[e.key],
                top: y[e.key],
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      slider = true;
                      key = e.key;
                    });
                    // return Container(
                    //   height: 200,
                    //   color: Colors.white,
                    //   child: Center(
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: <Widget>[
                    // BlockPicker(
                    //   layoutBuilder: (BuildContext context,
                    //       List<Color> colors, PickerItem child) {
                    //     return Container(
                    //       width: 400,
                    //       height: 100,
                    //       child: GridView.count(
                    //         crossAxisCount: 10,
                    //         crossAxisSpacing: 1.0,
                    //         mainAxisSpacing: 20.0,
                    //         children: colors
                    //             .map((Color color) => child(color))
                    //             .toList(),
                    //       ),
                    //     );
                    //   },
                    //   pickerColor: textColor[e.key],
                    //   onColorChanged: (c) {
                    //     setState(() {
                    //       textColor[e.key] = c;
                    //     });
                    //   },
                    // ),
                    //         Slider(
                    //           min: 5,
                    //           max: 65,
                    //           value: size,
                    //           onChanged: (v) {
                    //             size = v;
                    //             setState(() {
                    //               textSize[e.key] = v;
                    //             });
                    //           },
                    //         ),
                    //         RaisedButton(
                    //           child: const Text('Close BottomSheet'),
                    //           onPressed: () => Navigator.pop(context),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // );
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
            }).toList()),
            slider
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
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
                              pickerColor: textColor[key],
                              onColorChanged: (c) {
                                setState(() {
                                  textColor[key] = c;
                                });
                              },
                            ),
                            Slider(
                              min: 5,
                              max: 65,
                              value: textSize[key],
                              onChanged: (v) {
                                setState(() {
                                  textSize[key] = v;
                                });
                              },
                            ),
                            RaisedButton(
                                child: const Text('Close'),
                                onPressed: () {
                                  setState(() {
                                    slider = false;
                                  });
                                })
                          ],
                        ),
                      ),
                    ),
                  )
                : Positioned(bottom: 0, child: SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  editComplete() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Text(
        'Image saved in AppDirectory',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return done ? editComplete() : editor();
  }
}

class TextForm extends StatefulWidget {
  @override
  _TextFormState createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              height: 60,
              color: Colors.white,
              child: TextFormField(
                style: TextStyle(color: Colors.blue, fontSize: 20),
                controller: textController,
                decoration: InputDecoration(
                    hintText: "Write your text here", border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 28,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Apply',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pop(context, textController.text);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
