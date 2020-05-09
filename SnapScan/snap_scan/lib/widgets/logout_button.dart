import 'package:flutter/material.dart';
import 'package:snap_scan/api_services.dart';
import 'package:snap_scan/widgets/picture_taker.dart';
import 'package:snap_scan/areas/perf_area.dart';
import 'package:snap_scan/widgets/layout_elements.dart';

Widget login;

showLogoutDialog(BuildContext context) {
  // set up the buttons
  Widget noBtn = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget yesBtn = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      clearImages();
      updatePerf();
      clearAPI();
      Navigator.pushReplacement(context, Router(page: login, type: Type.right));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Log out?"),
    content: Text("All local images will be cleared."),
    actions: [noBtn, yesBtn],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

IconButton logoutBtn(BuildContext context, Color color) {
  return IconButton(
      icon: Icon(Icons.exit_to_app),
      iconSize: 32,
      color: color,
      onPressed: () {
        showLogoutDialog(context);
      });
}
