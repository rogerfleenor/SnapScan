import 'package:flutter/material.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:snap_scan/json_post.dart';
import 'package:snap_scan/api_services.dart';
import 'package:snap_scan/widgets/picture_taker.dart';
import 'package:flutter_qr_scanner/qr_scanner_camera.dart';

class ScannerArea extends StatefulWidget {
  final Widget page;

  ScannerArea(this.page);
  @override
  _ScannerAreaState createState() => new _ScannerAreaState();
}

class _ScannerAreaState extends State<ScannerArea> {
  GlobalKey<QRScannerCameraState> qrCameraKey = GlobalKey();
  bool _camState = true;
  Widget _page;

  @override
  initState() {
    _camState = true;
    _page = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(36.0),
        child: AppBar(
          title: Text("Scan Part", style: TextStyle(color: Colors.black)),
          automaticallyImplyLeading: false,
          backgroundColor: OrangeColor,
          elevation: 0,
        ),
      ),
      resizeToAvoidBottomInset: false, //don't resize to fit keyboard
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DividerLine(4, GreyColor, 0),
          TextField(
            //text input for looking up part or vehicle number
            onSubmitted: (String str) {
              tryItem(str);
            },
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: 'Enter R#'),
          ),
          DividerLine(4, GreyColor, 0),
          Expanded(
            //area for viewfinder/scanner
            child: Container(
                child: _camState
                    ? new Center(
                        child: new SizedBox(
                          //QrCamera has to be inside either a box or container
                          child: new QRScannerCamera(
                            key: qrCameraKey,
                            onError: (context, error) => Text(
                              error.toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                            child: DividerLine(4, RedColor.withAlpha(120), 0),
                            qrCodeCallback: (str) async {
                              print("SCANNNED ITEM");
                              qrCameraKey.currentState.stop();
                              //scanning barcodes returns a string that is passed to api
                              tryItem(str);
                            },
                          ),
                        ),
                      )
                    : new Center(
                        child: new Text("View Finder Off",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)))),
          ),
          DividerLine(4, GreyColor, 0),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: 'Toggle View Finder',
          mini: true,
          child: Icon(Icons.wb_iridescent, size: 28),
          backgroundColor: _camState ? RedColor : BlueColor,
          onPressed: () {
            setState(() {
              _camState = !_camState;
            });
          }),
    );
  }

//489509 is bad
  void tryItem(String code) async {
    final PostPart triedPart = await getPartsPost(context, code);
    if (triedPart == null) {
      qrCameraKey.currentState.restart();
      return;
    }
    globalPart = triedPart;
    globalPart.id = int.parse(code);
    Navigator.pushReplacement(
      context,
      Router(
          page: PictureTaker(_page),
          type: Type
              .forward), //navigates to camera and passes our details page for reference
    );
  }
}
