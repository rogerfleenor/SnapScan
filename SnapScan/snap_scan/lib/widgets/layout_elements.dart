import 'package:flutter/material.dart';
import 'package:snap_scan/widgets/logout_button.dart';

const OrangeColor = const Color(0xFFF0961E);
const GreyColor = const Color(0xFF323232);
const RedColor = const Color(0xFFE63C64);
const YellowColor = const Color(0xFFDCD328);
const GreenColor = const Color(0xFF3CBE5A);
const BlueColor = const Color(0xFF1EBEB4);

class DividerLine extends StatelessWidget {
  final double thickness;
  final Color color;
  final double padding;

  DividerLine(this.thickness, this.color, this.padding);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //simple box that looks like a line for dividing elements
      child: Center(
        child: Container(
          margin: EdgeInsetsDirectional.only(start: padding, end: padding),
          height: thickness,
          color: color,
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final Color textColor;
  final double textSize;
  final FontWeight textWeight;

  @override
  Size get preferredSize => Size.fromHeight(56);

  CustomAppBar(
      this.title, this.color, this.textColor, this.textSize, this.textWeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Container(
            padding: EdgeInsets.only(right: 8),
            child: logoutBtn(context, textColor)),
      ],
      leading: Container(
        height: 64.0,
        width: 64.0,
        padding: EdgeInsets.only(left: 16),
        child: Container(
          padding: EdgeInsets.all(0),
          child: Image.asset('assets/images/sslogo.png', color: textColor),
        ),
      ),
      title: Text(title,
          style: TextStyle(
              color: textColor, fontSize: textSize, fontWeight: textWeight)),
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      backgroundColor: color,
    );
  }
}

enum Type { forward, backward, right, left }

class Router extends PageRouteBuilder {
  final Widget page;
  final Type type;

  Router({this.page, this.type})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                (type == Type.right)
                    ? rightRoute(animation, child)
                    : (type == Type.left)
                        ? leftRoute(animation, child)
                        : (type == Type.forward)
                            ? forwardRoute(animation, child)
                            : backwardRoute(animation, child));
}

Widget forwardRoute(Animation<double> animation, Widget child) {
  return ScaleTransition(
    scale: Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      ),
    ),
    child: child,
  );
}

Widget backwardRoute(Animation<double> animation, Widget child) {
  return ScaleTransition(
    scale: Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      ),
    ),
    child: child,
  );
}

Widget rightRoute(Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

Widget leftRoute(Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

showAlertDialog(BuildContext context, int status, String msg) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Error " + status.toString()),
    content: Text(msg),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
