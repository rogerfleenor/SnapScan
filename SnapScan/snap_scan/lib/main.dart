import 'package:flutter/material.dart';
import 'package:snap_scan/widgets/image_settings.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:snap_scan/part_collection.dart';
import 'package:snap_scan/areas/login_area.dart';
import 'package:snap_scan/areas/history_area.dart';
import 'package:snap_scan/areas/scanner_area.dart';
import 'package:snap_scan/areas/perf_area.dart';
import 'package:snap_scan/areas/details_area.dart';
import 'package:snap_scan/areas/images_area.dart';
import 'package:snap_scan/widgets/logout_button.dart';

// entry point for the app,
// the => operator is shorthand for {} when there is only one line of code
void main() => runApp(SnapScan());

// the root widget of our application
class SnapScan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(scaffoldBackgroundColor: GreyColor),
      home: LoginPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, //ignore phone bottom back button
        child: Scaffold(
          appBar: CustomAppBar(
              "SnapScan", Colors.black, Colors.white, 25.0, FontWeight.bold),
          resizeToAvoidBottomInset: false, //don't resize to fit keyboard
          body: Column(
            //main page is made up of three rows
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                //upload history list
                flex: 3, //30% screen space
                child: HistoryArea(DetailsPage()),
              ),
              Expanded(
                //text field and view finder
                flex: 3, //30% screen space
                child: ScannerArea(DetailsPage()),
              ),
              Expanded(
                //user performance graph
                flex: 3, //30% screen space
                child: PerformanceArea(),
              ),
            ],
          ),
        ));
  }
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, //ignore phone bottom back button
        child: Scaffold(
          resizeToAvoidBottomInset: false, //don't resize to fit keyboard
          body: Column(
            //details page is made up of two rows
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 40, //40% screen space
                child: DetailsArea(), //text details for item
              ),
              Expanded(
                flex: 60, //60% screen space
                child: ImagesArea(MainPage(), DetailsPage()), // images for item
              ),
            ],
          ),
        ));
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false, //ignore phone bottom back button
        child: Scaffold(
          //resizeToAvoidBottomInset: false, //don't resize to fit keyboard
          backgroundColor: Colors.black,
          body: Column(
            //login page made up of 3 areas
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                //top with logo
                flex: 35, //split remaining screen
                child: Container(
                  child: Image.asset(
                    'assets/images/sslogo.png',
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
              ),
              Expanded(
                //login fields area
                flex: 65,
                //  height: 216, //20% screen space
                child: LoginArea(),
              ),
            ],
          ),
        ));
  }
}

void initApp() {
  login = LoginPage();
  initSettings();
  createCollection();
}
