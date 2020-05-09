import 'package:flutter/material.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:snap_scan/api_services.dart';
import 'package:snap_scan/json_post.dart';
import 'package:snap_scan/part_collection.dart';
import 'package:snap_scan/widgets/picture_taker.dart';
import 'package:snap_scan/areas/perf_area.dart';
import 'dart:io';

class ImagesArea extends StatefulWidget {
  final Widget mainPage;
  final Widget detailsPage;
  ImagesArea(this.mainPage, this.detailsPage);
  @override
  _ImagesAreaState createState() => _ImagesAreaState();
}

class _ImagesAreaState extends State<ImagesArea> {
  Widget _mainPage;
  Widget _detailsPage;
  bool viewLocals = false;

  @override
  void initState() {
    super.initState();
    _mainPage = widget.mainPage;
    _detailsPage = widget.detailsPage;
    if (globalPart.localImages.isNotEmpty) {
      viewLocals = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (globalPart == null) {
      return Container();
    }
    return Scaffold(
        body: displayImages(),
        floatingActionButton: Align(
            alignment: Alignment(1.0, 0.5),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              FloatingActionButton(
                  mini: true,
                  heroTag: null,
                  child: Icon(Icons.camera_roll),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: RedColor,
                  onPressed: () {
                    setState(() {
                      viewLocals = !viewLocals;
                    });
                  }),
              Padding(padding: EdgeInsets.all(12)),
              FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.add_a_photo),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: BlueColor,
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        Router(
                            page: PictureTaker(_detailsPage),
                            type: Type
                                .forward), //navigates to camera and passes our details page for reference
                      );
                    });
                  })
            ])));
  }

  Widget displayImages() {
    if (viewLocals) {
      return showLocals(globalPart.localImages.length);
      //if not check if we have server images
    } else if (globalPart.serverImages.isNotEmpty) {
      return showRemotes(globalPart.serverImages.length);
    }
    //otherwise show nothing
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Expanded(child: Container()), doneButton()]);
  }

  Container doneButton() {
    return Container(
      //bottom button to save and return to main page
      height: 56,
      child: FlatButton(
          color: OrangeColor,
          child: genText(),
          onPressed: () {
            if (globalPart.localImages.isNotEmpty) {
              globalPart.localImages.forEach((img) async => uploadLocal(img));
              if (!partCollection.hasPart(globalPart.id)) {
                //if collection doesn't already contain our current object
                partCollection.addPart(globalPart);
                //increment our user performance, since this is a new part
                incPerf();
              }
            }
            Navigator.pushReplacement(
              context,
              Router(
                  page: _mainPage,
                  type: Type.right), //navigates to main page passed from main
            );
          })
    );
  }

  Text genText() {
    if (globalPart.localImages.isNotEmpty) {
      return Text("Upload");
    }
    return Text("Done");
  }

  Column showLocals(int count) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DividerLine(4, GreyColor, 0),
          Expanded(
              //images take up the entire allowed area
              child: GridView.builder(
            padding: EdgeInsets.all(0),
            itemCount: count,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 4),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Hero(
                  tag: 'localHero$index',
                  child: Container(
                      child: Image.file(File(globalPart.localImages[index]),
                          fit: BoxFit.cover)),
                ),
                onLongPress: () {
                  setState(() {
                    globalPart.locals--;
                    Directory(globalPart.localImages[index])
                        .deleteSync(recursive: true); //delete file from device
                    globalPart.localImages
                        .removeAt(index); //remove displayed image
                  });
                },
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return BigImage(
                        Image.file(File(globalPart.localImages[index]),
                            fit: BoxFit.contain, alignment: Alignment.center),
                        'localHero$index'); //fullscreen image
                  }));
                },
              );
            },
          )),
          DividerLine(4, GreyColor, 0),
          doneButton()
        ]);
  }

  Column showRemotes(int count) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DividerLine(4, GreyColor, 0),
          Expanded(
              //images take up the entire allowed area
              child: GridView.builder(
            padding: EdgeInsets.all(0),
            itemCount: count,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 4),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Hero(
                  tag: 'serverHero$index',
                  child: Container(
                      child: Image.network(globalPart.serverImages[index].url,
                          fit: BoxFit.cover)),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return BigImage(
                        Image.network(globalPart.serverImages[index].url,
                            fit: BoxFit.contain, alignment: Alignment.center),
                        'serverHero$index'); //fullscreen image
                  }));
                },
              );
            },
          )),
          DividerLine(4, GreyColor, 0),
          doneButton()
        ]);
  }

  void uploadLocal(String img) async {
    PostStatus triedImg;
    triedImg = await sendImagePost(File(img));
    //if we get a status, something went wrong
    if (triedImg.status != -1 && triedImg.status != 201) {
      showAlertDialog(
          context, triedImg.status, triedImg.msg); //show error message
      return;
    }
    globalPart.uploads.value++;
    Directory(img).deleteSync(recursive: true); //delete file from device
    globalPart.localImages.remove(img); //remove displayed image
  }
}

class BigImage extends StatelessWidget {
  final Image image;
  final String tag;

  BigImage(this.image, this.tag);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Hero(
            tag: tag,
            child: Center(
              child: image,
            )),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
