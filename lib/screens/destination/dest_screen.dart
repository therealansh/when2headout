import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overlapping_time/overlapping_time.dart';
import 'package:travel/constants.dart';
import 'package:travel/models/groups.dart';
import 'package:travel/screens/home/components/top_travelers.dart';
import 'package:travel/screens/home/home_screen.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({ Key? key, required this.groupId}) : super(key: key);

  final String groupId;

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {

  @override
  void initState() {    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection("groups").doc(widget.groupId).get(),
        builder: (context,snapshot){
          if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Center(child: Text("No Data"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
           return MainContainer(title: data["name"], image: "assets/images/home_bg.png", rating: 4.5,friends: data["members"].length,id: widget.groupId,days:data["days"], isPlanned: false,available: DateTimeRange(start: (data["available"]["start"] as Timestamp).toDate(), end: (data["available"]["end"] as Timestamp).toDate()),);
        }
           return Center(child: CircularProgressIndicator());
        }
      )
    );
  }
}

class MainContainer extends StatefulWidget  {

  final String title, image, id;
  final double rating;
  final int friends;
  final List<dynamic> days;
  final bool isPlanned;
  final DateTimeRange available;

  MainContainer ({
    required this.id,
    required this.title,
    required this.image,
    required this.rating,
    required this.friends,
    required this.days,
    required this.isPlanned,
    required this.available,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> with SingleTickerProviderStateMixin{
  DateTime startDate = DateTime.now();

  DateTime endDate = DateTime.now();

  Future openDateRangeSelector(context) async {
    var dateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (dateRange == null) return;

    await firestore.collection("groups").doc(widget.id).update(
      {
        "days": FieldValue.arrayUnion([
          {
            "start": dateRange.start,
            "end": dateRange.end
          }
        ]),
        "members": FieldValue.arrayUnion([user!.uid])
      }
    );

  //BUSINESS LOGIC
    var timeRangeList = widget.days.map((e) => DateTimeRange(
      start: (e["start"] as Timestamp).toDate(),
      end: (e["end"] as Timestamp).toDate()
    )).toList();
    timeRangeList.add(DateTimeRange(start: dateRange.start, end: dateRange.end));
    timeRangeList.sort((a, b) => a.start.compareTo(b.start));
    DateTimeRange ans;
    var l = timeRangeList[0].start;
    var r = timeRangeList[0].end;
    for(var i =1;i<timeRangeList.length;i++){
      if(timeRangeList[i].start.isAfter(r) || timeRangeList[i].end.isBefore(l)){
        l = DateTime(2019);
        r = DateTime(2019);
        break;
      }else{
        if(timeRangeList[i].start.isAfter(l)) l = timeRangeList[i].start;
        if(timeRangeList[i].end.isBefore(r)) r = timeRangeList[i].end;
      }
    }
    ans = DateTimeRange(start:l, end:r);
    print(ans);

   await firestore.collection("groups").doc(widget.id).update({
     "available": {"start": ans.start, "end":ans.end}
   });

    setState(() {
      startDate = dateRange.start;
      endDate = dateRange.end;
    });
  }

  String processRange(DateTimeRange avail) {
    if(avail.start == avail.end && avail.start.isBefore(DateTime.now())) return "Not Available :(";
    String date1 = DateFormat("dd/MM/yyyy").format(avail.start);
    String date2 = DateFormat("dd/MM/yyyy").format(avail.end);
    return "$date1 - $date2";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Container(
                width: double.infinity,
                color: Color.fromRGBO(247, 247, 249, 1),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40.0),
                          bottomRight: Radius.circular(40.0)
                      ),
                      image: DecorationImage(
                        image: AssetImage(widget.image),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 30, top: 40),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0)
                          ),
                          child: RawMaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: new Icon(
                              Icons.arrow_back,
                              color: Color.fromRGBO(57,182,245, 1),
                              size: 30.0,
                            ),
                            shape: new CircleBorder(),
                            elevation: 2.0,
                            fillColor: Colors.white,
                            padding: const EdgeInsets.all(5.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(247, 247, 249, 1),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)
                    )
                ),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 40, top: 20),
                        child: Text(widget.title, textScaleFactor: 2, style: TextStyle(color: Color.fromRGBO(19, 33, 70, 1), fontWeight: FontWeight.bold, ),),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 40, top: 15, right: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.star, color: Colors.orange,),
                                Container(margin: EdgeInsets.only(left: 5), child: Text(widget.rating.toString(), textScaleFactor: 1.2, style: TextStyle(color: Colors.orange),),)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.cloud, color: Colors.indigo[100],),
                                Container(margin: EdgeInsets.only(left: 5), child: Text("25 ℃", textScaleFactor: 1.2, style: TextStyle(color: Colors.indigo[100]),),)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.airplanemode_active, color: Colors.indigo[100],),
                                Container(margin: EdgeInsets.only(left: 5), child: Text("2 miles", textScaleFactor: 1.2, style: TextStyle(color: Colors.indigo[100]),),)
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Center(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: CircleTabIndicator(color: Color.fromRGBO(57,182,245, 1), radius: 2),
                        unselectedLabelColor: Colors.indigo[100],
                        labelColor: Color.fromRGBO(57,182,245, 1),
                        indicatorColor: Colors.transparent,
                        labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        tabs: [
                          Container(height: 30, child: Tab(text: "Hotels & Flights")),
                          Container(height: 30, child: Tab(text: "Experiences",)),
                        ],
                      ),
                      Container(
                        constraints: BoxConstraints(minHeight: 100, minWidth: 100),
                        height: 142,
                        margin: EdgeInsets.only(left: 20, top: 15, right: 20),
                        child: TabBarView(
                            children: [
                              Center(child: Text("Text Description"),),
                              Center(child: Text("Text Description"),),
                            ]
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.indigo[800],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)
                    )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 30, top: 20),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Friends in plan:", style: TextStyle(color: Colors.indigo[100]),),
                        Text(widget.friends.toString(), textScaleFactor: 1.4, style: TextStyle(color: Colors.white),)
                      ],
                    ),),
                    Container(
                      padding: EdgeInsets.only(top: 15, right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(14))
                            ),
                            child: FlatButton(
                              onPressed: widget.isPlanned ? (){} : () {
                                openDateRangeSelector(context);
                              },
                              child: Text(widget.isPlanned ? processRange(widget.available):"Plan yours", textScaleFactor: 1.4, style: TextStyle(color: kPrimaryColor),),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color? color, @required double? radius}) : _painter = _CirclePainter(color!, radius!);

  @override
BoxPainter createBoxPainter([ VoidCallback? onChanged ]) {
  return _painter;
}
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset = offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}