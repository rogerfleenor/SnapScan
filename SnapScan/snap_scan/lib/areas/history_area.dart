import 'package:flutter/material.dart';
import 'package:snap_scan/part_collection.dart';
import 'package:snap_scan/widgets/layout_elements.dart';
import 'package:snap_scan/widgets/history_item.dart';
import 'package:snap_scan/json_post.dart';

class HistoryArea extends StatefulWidget {
  final Widget page; //details page

  HistoryArea(this.page);
    @override
  _HistoryAreaState createState() => new _HistoryAreaState();
}

class _HistoryAreaState extends State<HistoryArea> {
  Widget _page;
  
  @override
  initState() {
    _page = widget.page;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(36.0),
        child: AppBar(
          title: Text("Upload History", style: TextStyle(color: Colors.black)),
          automaticallyImplyLeading: false,
          backgroundColor: OrangeColor,
          elevation: 0,  //0 removes drop shadow
        ),
      ),
      resizeToAvoidBottomInset: false,  //don't resize to fit keyboard
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DividerLine(4, GreyColor, 0),
          Expanded( //history takes up entire allowed area
            child: ListView.separated(
              itemCount: partCollection.getCollection().length,
              itemBuilder: (BuildContext context, int index) {
                PostPart part = partCollection.partByIndex(index);
                return Container( //list entries are white rectangles
                  height: 60,
                  color: Colors.white,
                  child: ValueListenableBuilder<int>(
                    valueListenable: part.uploads,
                    builder: (context, value, child) {
                      return HistoryItem(part, _page);
                    }
                  )
               //   HistoryItem(part, _page, part.uploads),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 4),  //the space between list items
            ),
          ),
          DividerLine(4, GreyColor, 0),
        ],
      ),
    );
  }
}

