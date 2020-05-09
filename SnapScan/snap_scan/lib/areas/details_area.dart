import 'package:flutter/material.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:snap_scan/api_services.dart';

class DetailsArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(globalPart == null) {
      return Container();
    }
    return Scaffold(
      appBar: CustomAppBar(
          globalPart.roNum, OrangeColor, Colors.black, 25.0, FontWeight.bold),
      resizeToAvoidBottomInset: false, //don't resize to fit keyboard
      body: Column(
        children: [
          Expanded(
            //take up the entire allowed area
            child: Container(
              //give the entire detail text area a white baground
              color: Colors.white,
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
              child: Column(
                //3 sections; part info, notes, image count
                children: [
                  Container(
                    //part or vehicle info
                    child: Column(
                        //details page is made up of two rows
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                  globalPart.modelYear.toString() +
                                      " " +
                                      globalPart.modelName,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(globalPart.partName,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold))),
                          Row(children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      child: Text(
                                          'Interchange: ' + globalPart.invNum,
                                          style: TextStyle(fontSize: 16.0))),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      child: Text(
                                          'Stock #: ' + globalPart.stockNum,
                                          style: TextStyle(fontSize: 16.0))),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      child: Text('Grade: ' + globalPart.rating,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 16.0))),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2),
                                      child: Text(
                                          'Location: ' + globalPart.location,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(fontSize: 16.0))),
                                ],
                              ),
                            ),
                          ]),
                        ]),
                  ),
                  DividerLine(4, OrangeColor, 0),
                  Expanded(
                    //notes will expand to take up more space if necessary
                    child: Container(
                        alignment: Alignment(-1.0, 0),
                        child: SingleChildScrollView(
                            child: Text('Notes: ' + globalPart.notes,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style:
                                    TextStyle(fontSize: 16.0, height: 1.20)))),
                  ),
                  DividerLine(4, OrangeColor, 0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment(-1.0, 0),
                            child: Text(
                                'Server Images: ' +
                                    globalPart.serverImages.length.toString(),
                                style:
                                    TextStyle(fontSize: 16.0, height: 1.20))),
                        Container(
                            alignment: Alignment(-1.0, 0),
                            child: Text(
                                'Local Images: ' +
                                    globalPart.localImages.length.toString(),
                                style:
                                    TextStyle(fontSize: 16.0, height: 1.20))),
                      ])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
