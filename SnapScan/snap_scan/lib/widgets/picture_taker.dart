import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:snap_scan/api_services.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:snap_scan/json_post.dart';
import 'package:snap_scan/part_collection.dart';
import 'dart:io';
import 'package:flutter/painting.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:image/image.dart' as img;
import 'package:snap_scan/widgets/image_settings.dart';

List<CameraDescription> cameras;

// A screen that allows users to take a picture using a given camera.
class PictureTaker extends StatefulWidget {
  final Widget page;
  PictureTaker(this.page);
  @override
  PictureTakerState createState() => PictureTakerState();
}

class PictureTakerState extends State<PictureTaker> {
  List<CameraDescription> cameras;
  List<String> paths = new List<String>();
  CameraController _controller;
  Future<void> _controllerFuture;
  bool isReady = false;
  Widget _page;

  @override
  void initState() {
    super.initState();
    _page = widget.page;
    setupCameras();
  }

  Future<void> setupCameras() async {
    try {
      cameras = await availableCameras();
      _controller = new CameraController(cameras[0], getRes());
      _controllerFuture = _controller.initialize();
    } on CameraException catch (_) {
      setState(() {
        isReady = false;
      });
    }
    setState(() {
      isReady = true;
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: FutureBuilder<void>(
          future: _controllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return GestureDetector(
                  onTap: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _controllerFuture;

                      // Construct the path where the image should be saved using the
                      // pattern package.
                      final path = join(
                        // Store the picture in the temp directory.
                        // Find the temp directory using the `path_provider` plugin.
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.jpg',
                      );

                      // Attempt to take a picture and log where it's been saved.
                      await _controller.takePicture(path);
                      img.Image image =
                          img.decodeJpg(File(path).readAsBytesSync());
                      //-25 -20 -15 -10 -5 0 5 10 15 20 25
                      img.brightness(image, getBright());
                      img.contrast(image, (100 + getContra()));
                      File(path).writeAsBytesSync(img.encodeJpg(image));
                      paths.add(path);
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                  child: CameraPreview(_controller));
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: Column(mainAxisSize: MainAxisSize.min, children: [
          FloatingActionButton(
              mini: true,
              heroTag: null,
              child: Icon(Icons.settings),
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: RedColor,
              onPressed: () {
                for (int i = 0; i < paths.length; i++) {
                  Directory(paths[i]).deleteSync(recursive: true); //delete any images already taken
                }
                Navigator.pushReplacement(
                    context,
                    //leave the camera view and go to settings page
                    Router(page: ImageSettings(_page), type: Type.right));
              }),
          Padding(padding: EdgeInsets.all(12)),
          FloatingActionButton(
            child: Icon(Icons.exit_to_app),
            backgroundColor: BlueColor,
            // Provide an onPressed callback.
            onPressed: () {
              PostPart part = partCollection.partById(globalPart
                  .id); //check if we already have a local object for this item or make a new one
              globalPart = part;
              if (paths.isNotEmpty) {
                if (globalPart.localImages.isEmpty) {
                  globalPart.localImages =
                      paths; //set obj image paths compeletely
                } else {
                  List<String> merged = List.from(globalPart.localImages)
                    ..addAll(
                        paths); //combine existing list with our newly generated paths
                  globalPart.localImages =
                      merged; //add new image paths to existing paths list on local object
                }
                globalPart.locals += paths.length;
              }
              Navigator.push(
                  context,
                  //leave the camera view and go to details page
                  Router(page: _page, type: Type.forward));
            },
          )
        ]));
  }
}

void clearImages() async {
  Directory dir = await getTemporaryDirectory();
  dir.deleteSync(recursive: true);
  imageCache.clear();
}

class Snapper extends StatefulWidget {
//  final Text text;
//  Snapper(this.text);
  @override
  SnapperState createState() => SnapperState();
}

class SnapperState extends State<Snapper> with SingleTickerProviderStateMixin {
  AnimationController _animController;
  Animation _anim;
//  Text _text;
//  bool fadeIn;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(duration: Duration(milliseconds: 10), vsync: this);
    _anim = Tween(begin: 0.0, end: 1.0).animate(_animController);
    // _text = widget.text;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animController.forward();
    return FadeTransition(opacity: _anim, child: Text("SNAP!"));
  }
}
