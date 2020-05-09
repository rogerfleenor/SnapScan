import 'package:flutter/material.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:camera/camera.dart';
import 'package:snap_scan/widgets/picture_taker.dart';

SharedPreferences prefs;
int resolution;
int brightness;
int contrast;
final List<String> resolutions = ["240", "480", "720", "1080", "2160", "Full"];
final List<int> brightsContras = [
  0,
  -50,
  10,
  -40,
  20,
  -30,
  30,
  -20,
  40,
  -10,
  50,
  0
];

// size resolutions 1: 240, 2: 480, 3: 720, 4: 1080, 5: full
ResolutionPreset getRes() {
  if (resolution == 0) {
    return ResolutionPreset.low;
  }
  if (resolution == 1) {
    return ResolutionPreset.medium;
  }
  if (resolution == 2) {
    return ResolutionPreset.high;
  }
  if (resolution == 3) {
    return ResolutionPreset.veryHigh;
  }
  if (resolution == 4) {
    return ResolutionPreset.ultraHigh;
  }
  if (resolution == 5) {
    return ResolutionPreset.max;
  }
  return ResolutionPreset.high;
}

int getBright() {
  return brightsContras[brightness];
}

int getContra() {
  return brightsContras[contrast];
}

void initSettings() async {
  prefs = await SharedPreferences.getInstance();
  resolution = prefs.getInt("resolution") ?? 2;
  brightness = prefs.getInt("brightness") ?? 5;
  contrast = prefs.getInt("contrast") ?? 5;
}

// A screen that allows users to take a picture using a given camera.
class ImageSettings extends StatefulWidget {
  final Widget page;
  ImageSettings(this.page);
  @override
  ImageSettingsState createState() => ImageSettingsState();
}

class ImageSettingsState extends State<ImageSettings> {
  Widget _page;
  // SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _page = widget.page;
    //  _prefs = prefs;
  }

  //   @override
  // void dispose() {
  // Dispose of the controller when the widget is disposed.
  //_controller.dispose();
  //   super.dispose();
  // }

  String rTitle = "Resolution";
  String bTitle = "Brightness";
  String cTitle = "Contrast";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Image Settings"),
        backgroundColor: GreyColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            children: [
              Padding(padding: EdgeInsets.all(24)),
              Text(rTitle + ": " + resolutions[resolution], style: TextStyle(fontSize: 16)),
              Padding(padding: EdgeInsets.all(6)),
              Container(
                alignment: Alignment.center,
                height: 48,
                child: GridView.count(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(resolutions.length, (index) {
                    return resBtn(resolutions[index], index);
                  }),
                ),
              ),
              Padding(padding: EdgeInsets.all(12)),
              Text(bTitle + ": " + brightsContras[brightness].toString(), style: TextStyle(fontSize: 16)),
              Padding(padding: EdgeInsets.all(6)),
              Container(
                  alignment: Alignment.center,
                  height: 104,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(brightsContras.length, (index) {
                      return bcBtn(bTitle, index);
                    }),
                  )),
              Padding(padding: EdgeInsets.all(12)),
              Text(cTitle + ": " + brightsContras[contrast].toString(), style: TextStyle(fontSize: 16)),
              Padding(padding: EdgeInsets.all(6)),
              Container(
                  alignment: Alignment.center,
                  height: 104,
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(brightsContras.length, (index) {
                      return bcBtn(cTitle, index);
                    }),
                  )),
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(flex: 50, child: 
              Container(
                //bottom button to save and return to main page
                height: 56,
                child: FlatButton(
                    color: OrangeColor,
                    child: Text("Reset"),
                    onPressed: () {
                      setState(() {
                        clearSettings();
                      });
                    }),
              )),
              Expanded(flex: 50, child: 
              Container(
                  //bottom button to save and return to main page
                  height: 56,
                  child: FlatButton(
                      color: OrangeColor,
                      child: Text("Save"),
                      onPressed: () {
                        setState(() {
                          saveSettings();
                          Navigator.push(
                              context,
                              Router(
                                  page: PictureTaker(_page),
                                  type: Type
                                      .forward)); //navigates to camera and passes our details page for reference
                        });
                      })))
            ],
          )
        ],
      ),
    );
  }

  Container resBtn(String label, int res) {
    return Container(
        width: 48,
        height: 48,
        child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: GreyColor,
            highlightColor: OrangeColor,
            splashColor: OrangeColor,
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            onPressed: () {
              setState(() {
                resolution = res;
              });
            },
            child: Text(label, style: TextStyle(fontSize: 12))));
  }

  Container bcBtn(String type, int index) {
    return Container(
        width: 48,
        height: 48,
        child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: GreyColor,
            highlightColor: OrangeColor,
            splashColor: OrangeColor,
            textColor: Colors.white,
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            onPressed: () {
              setState(() {
                if (type == "Brightness") {
                  brightness = index;
                } else if (type == "Contrast") {
                  contrast = index;
                }
              });
            },
            child: Text(brightsContras[index].toString(),
                style: TextStyle(fontSize: 12))));
  }

  saveSettings() {
    prefs.setInt("resolution", resolution);
    prefs.setInt("brightness", brightness);
    prefs.setInt("contrast", contrast);
  }

  clearSettings() {
    prefs.remove("resolution");
    prefs.remove("brightness");
    prefs.remove("contrast");
    resolution = 2;
    brightness = 0;
    contrast = 0;
  }
}
