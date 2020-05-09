import 'dart:convert';
import 'package:flutter/foundation.dart';

PostLogin fromLogin(String str) {
  final jsonData = json.decode(str);
  return PostLogin.fromJson(jsonData);
}

class PostLogin {
  String accToken;
  int status;
  String msg;

  PostLogin({
    this.accToken, 
    this.status, 
    this.msg
    });

  factory PostLogin.fromJson(Map<String, dynamic> json) => new PostLogin(
      accToken: json["AccessToken"],
      status: json["Status"],
      msg: json["Message"]);
}

PostPart fromParts(String str) {
  final Map jsonData = json.decode(str);
  return PostPart.fromJson(jsonData);
}

class PostPart {
  int id;
  String roNum;
  int modelYear;
  String modelName;
  String partName;
  String invNum;
  String stockNum;
  String rating;
  String location;
  String notes;
  int imageCount;
  List<PostImage> serverImages = new List<PostImage>();
  int status;
  String msg;
  
  int locals = 0;
  final uploads = new ValueNotifier(0);
  List<String> localImages = new List<String>();

  PostPart(
      {
      this.roNum,
      this.modelYear,
      this.modelName,
      this.partName,
      this.invNum,
      this.stockNum,
      this.rating,
      this.location,
      this.notes,
      this.imageCount,
      this.serverImages,
      this.status,
      this.msg
      });

  factory PostPart.fromJson(Map<String, dynamic> json) {

    var imagesJson = json["ImageList"] as List;
    //List<String> imagesList = imagesJson.cast<String>();
    List<PostImage> imagesList = imagesJson.map((i) => PostImage.fromJson(i)).toList();

    return PostPart(
        roNum: json["RoNumber"],
        modelYear: json["ModelYear"],
        modelName: json["ModelName"],
        partName: json["PartName"],
        invNum: json["InventoryNumber"],
        stockNum: json["StockTicketNumber"],
        rating: json["PartRating"],
        location: json["LocationCode"],
        notes: json["PartNotes"],
        imageCount: json["TotalImage"],
        serverImages: imagesList,
        status: json["Status"],
        msg: json["Message"]);
  }
}

class PostImage {
  final String url;

  PostImage({this.url});

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      url: json["FileUrl"]
    );
  }
}

PostStatus fromStatus(String str) {
  final jsonData = json.decode(str);
  return PostStatus.fromJson(jsonData);
}

class PostStatus {
  int status = -1;
  String msg;

  PostStatus({
    this.status, 
    this.msg
    });

  factory PostStatus.fromJson(Map<String, dynamic> json) => new PostStatus(
      status: json["Status"],
      msg: json["Message"]);
}

///PERFORMANCE - Roger Fleenor

//Performance fromPerformance(String str) {
 //   final jsonData = json.decode(str);
 //   return Performance.fromJson(jsonData);
//}

class Performance {
  final String id;
  String today = "0";
  String best = "0";
  String average = "0";
  String days = "0";

  Performance({this.id, this.today, this.best, this.average, this.days});

  Performance.fromJson(Map json)
      : id = json["_id"]["\$oid"],
        today = json["today"],
        best = json["best"],
        average = json["average"],
        days = json["days"];

  Map toJson() {
    return {
      'id': id,
      'today': today,
      'best': best,
      'average': average,
      'days': days
    };
  }

}



//average ((old avg * days ) + today ) / (days + 1)