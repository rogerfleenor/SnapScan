import 'package:flutter/material.dart';
import 'package:snap_scan/api_services.dart';
import 'package:snap_scan/json_post.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HistoryItem extends StatefulWidget {
  final PostPart part; //part held in this list item
  final Widget page; //details page

  HistoryItem(this.part, this.page);
  @override
  _HistoryItemState createState() => new _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  PostPart _part;
  Widget _page;

  @override
  initState() {
    _part = widget.part;
    _page = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ValueListenableBuilder<int>(
              valueListenable: _part.uploads,
              builder: (context, value, child) {
                return CircularPercentIndicator(
                  animation: false,
                  radius: 44.0,
                  lineWidth: 6.0,
                  percent: genFill(), //show progresss based on images uploades divided by total local images
                  circularStrokeCap: CircularStrokeCap.square,
                  center: new Text(
               //     _part.serverImages.length
               //         .toString(), //show how many images on server
               (_part.serverImages.length + _part.uploads.value).toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  progressColor: genColor()
                );
              }),
          Container(
              constraints: BoxConstraints(minWidth: 224, maxWidth: 256),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${_part.roNum}' +
                            ' ' +
                            '${_part.modelYear}' +
                            ' ' +
                            '${_part.modelName}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis),
                    Text('${_part.partName}',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis)
                  ])),
          IconButton(
              //each entry has an orange arrow to press to view item details
              icon: Icon(Icons.arrow_forward_ios, size: 48, color: OrangeColor),
              padding: EdgeInsets.all(0),
              onPressed: () {
                setState(() {
                  globalPart = _part;
                  Navigator.pushReplacement(
                    context,
                    Router(page: _page, type: Type.left), //navigates to details page passed from main
                  );
                });
              }),
        ]);
  }
  double genFill(){
    if(_part.uploads.value / _part.locals < 1.0) {
      return _part.uploads.value / _part.locals;
    }
      return 1.0;
  }
  Color genColor(){
    double value = _part.uploads.value / _part.locals;
    if (value >= 1.0) {
      return BlueColor;
    }
    if (value >= 0.66) {
      return GreenColor;
    }
    if (value >= 0.33) {
      return YellowColor;
    }
    else {
      return RedColor;
    }
  }
}
