import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:snap_scan/json_post.dart';
import 'package:snap_scan/widgets/layout_elements.dart';

String _token;
String _id;
PostPart globalPart;
Performance performance;
bool perfFetched = false;

String get getToken {
  return _token;
}

set setToken(String t) {
  _token = t;
}

int get getId {
  int idNum = int.parse(_id);
  return idNum;
}

set setId(String i) {
  _id = i;
}

//reset values used for api
void clearAPI() {
  _token = null;
  _id = null;
  globalPart = null;
  performance = null;
}

//420512
Future<PostLogin> getLoginPost(String user, String pass) async {
  var uriLogin = Uri.http("api.benzeenautoparts.com", "/WebApi/Authenticate",
      {"UserName": user, "UserPassword": pass});
  final response = await http.post(uriLogin);
  return fromLogin(response.body);
}

Future<PostPart> getPartsPost(BuildContext context, String id) async {
  var uriParts = Uri.http("api.benzeenautoparts.com", "/WebApi/ViewPartDetails",
      {"AccessToken": _token, "PartId": id});
  final response = await http.post(uriParts);
  PostStatus part = fromStatus(response.body);
  if (part.status != null) {
    print("STATUS NOT NULL");
    //if we get expired access error
    if (part.status == 200 || part.status == 202 || part.status == 204) {
      showAlertDialog(
          context,
          part.status,
          part.msg +
              "\n\nRe-login to this fix this issue."); //show error message and tell user to re log in.
    } else {
      showAlertDialog(context, part.status, part.msg); //show error message
    }
    return null;
  }
  //else we are good
  return fromParts(response.body);
}

Future<PostStatus> sendImagePost(File img) async {
  List<int> imgBytes = await img.readAsBytes();
  String img64 = base64UrlEncode(imgBytes);
  var url = "http://api.benzeenautoparts.com/WebApi/UploadImageAssets";

  Map data = {
    "AccessToken": _token,
    "PartId": globalPart.id.toString(),
    "PartImage": img64
  };

  //encode Map to JSON
  var body = json.encode(data);
  var response = await http.post(url,
      //  headers: {"Content-Type": "application/json"},
      body: body);
  print(response.body);
  return fromStatus(response.body);
}

//Will pull record total based on today's date
Future<Performance> getPerformance() async {
  String perfKey = "EaOSBXwShg573pbCJR4KrbxhFSqt7b_q";
  String id = "5db9ffed7c213e208d1bc782";
//  https://api.mlab.com/api/1/databases/snap-scan/collections/performance?apiKey=EaOSBXwShg573pbCJR4KrbxhFSqt7b_q
  var response = await http.get(
      "https://api.mlab.com/api/1/databases/snap-scan/collections/performance/$id?apiKey=$perfKey");
  var jsonPerf = json.decode(response.body);
  Performance perf = Performance.fromJson(jsonPerf);
  return perf;
}

Future<bool> putPerformance() async {
  String perfKey = "EaOSBXwShg573pbCJR4KrbxhFSqt7b_q";
  String id = "5db9ffed7c213e208d1bc782";
  var response = await http.put(
    "https://api.mlab.com/api/1/databases/snap-scan/collections/performance/$id?apiKey=$perfKey",
    headers: {"Content-Type": "application/json"},
    body: json.encode(performance.toJson()),
  );
  print(response.statusCode);
  return response.statusCode == 200;
}
