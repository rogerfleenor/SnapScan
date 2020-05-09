import 'package:flutter/material.dart';
import 'package:snap_scan/json_post.dart';
import 'package:snap_scan/api_services.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:snap_scan/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginArea extends StatefulWidget {
  @override
  _LoginAreaState createState() => new _LoginAreaState();
}

class _LoginAreaState extends State<LoginArea> {
  final _user = new TextEditingController();
  final _pass = new TextEditingController();
  bool _remember = false;
  bool _attempted = false;
  SharedPreferences _prefs;
  final _formKey = new GlobalKey<FormState>();
  final _scaffKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    getCreds(); //if "remember me" check box was filled during last login, autofill credentials on next start up
  }

  @override
  void dispose() {
    // other dispose methods
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  void submit() {
    final _form = _formKey.currentState;
    _form.save(); //save text inside text form fields
    tryLogin();
  }

  void tryLogin() async {
    FocusScope.of(context).unfocus(); //close keyboard
    showLoging();
    final PostLogin triedLogin = await getLoginPost(_user.text, _pass.text);
    //if we get a status, something went wrong
    if (triedLogin.status != null) {
      //if we get expired access error and its our first attempt at loging in
      if (triedLogin.status == 204 && !_attempted) {
        _attempted = true;
        tryLogin(); //try logging in again
      } else {
        showAlertDialog(
            context, triedLogin.status, triedLogin.msg); //show error message
      }
      hideLoging();
      //else we are good
    } else {
      setToken = triedLogin.accToken;
      if (_remember) {
        saveCreds();
      } else {
        clearCreds();
      }
      initApp();
      perfFetched = false;
      hideLoging();
      Navigator.pushReplacement(context, Router(page: MainPage(), type: Type.left));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: OrangeColor,
        key: _scaffKey,
        resizeToAvoidBottomInset: false, //don't resize to fit keyboard
        body: Column(children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: _user,
                        style: TextStyle(fontSize: 20),
                        //store entered text to username variable
                        onSaved: (val) => _user.text = val,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 16, top: 8, right: 16, bottom: 8),
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Username'),
                      ),
                      DividerLine(16, OrangeColor, 24),
                      TextFormField(
                        controller: _pass,
                        obscureText: true,
                        style: TextStyle(fontSize: 20),
                        //store entered text to password variable
                        onSaved: (val) => _pass.text = val,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 16, top: 8, right: 16, bottom: 8),
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'Password'),
                      ),
                    ])),
                DividerLine(16, OrangeColor, 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Transform.scale(
                          scale: 2.0,
                          child: Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            activeColor: GreyColor,
                            value: _remember,
                            onChanged: (bool value) {
                              setState(() {
                                _remember = value;
                              });
                            },
                          )),
                      Text(" Remember ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GreyColor))
                    ]),
                    FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: GreyColor,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(
                            left: 40, top: 12, right: 40, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        onPressed: submit,
                        child: Text("Log In", style: TextStyle(fontSize: 16))),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            //black bottom
            child: Container(color: Colors.black),
          ),
        ]));
  }

  // if "remember me" box is checked, autofills credentials
  getCreds() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _remember = _prefs.getBool("remValue") ?? false;
      if (_remember) {
        _user.text = _prefs.getString("userValue") ?? "";
        print(_user);
        _pass.text = _prefs.getString("passValue") ?? "";
      }
    });
  }

  saveCreds() {
    _prefs.setBool("remValue", _remember);
    _prefs.setString("userValue", _user.text);
    _prefs.setString("passValue", _pass.text);
  }

  clearCreds() {
    _prefs.remove("remValue");
    _prefs.remove("userValue");
    _prefs.remove("passValue");
  //  _prefs.clear();
  }

  void showLoging() {
    _scaffKey.currentState.showSnackBar(//display bottom login progress banner
        new SnackBar(
            backgroundColor: GreyColor,
            duration: Duration(seconds: 30),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("    Logging in...")
                ])));
  }

  void hideLoging() {
//  scaffKey.currentState.hideCurrentSnackBar();
    _scaffKey.currentState.removeCurrentSnackBar();
  }
}
