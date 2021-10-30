import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlapping_time/overlapping_time.dart';
import 'package:travel/constants.dart';
import 'package:travel/models/groups.dart';
import 'package:travel/screens/home/components/top_travelers.dart';
import 'package:travel/screens/home/home_screen.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({ Key? key, required this.groupId }) : super(key: key);

  final String groupId;

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {

  @override
  void initState() {    
    super.initState();
  }

  List<String> images = [
     "https://images.unsplash.com/photo-1607355739828-0bf365440db5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1444&q=80",
      "https://images.unsplash.com/photo-1577791465485-b80039b4d69a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80",
      "https://images.unsplash.com/photo-1577404699057-04440b45986f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=752&q=80",
      "https://images.unsplash.com/photo-1549973890-38d08b229439?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=642&q=80",
      "https://images.unsplash.com/photo-1622263096760-5c79f72884af?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80"
      "https://images.pexels.com/photos/2583852/pexels-photo-2583852.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
      "https://images.unsplash.com/photo-1570789210967-2cac24afeb00?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
      "https://images.unsplash.com/photo-1516690561799-46d8f74f9abf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
      "https://live.staticflickr.com/1449/23852180634_54f8aa0404_b.jpg",
      "https://cdn.pixabay.com/photo/2017/08/09/12/05/piaynemo-2614341_960_720.jpg"
  ];

  final _pageController = PageController();


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
           return MainContainer(title: data["name"], image: "assets/images/home_bg.png", rating: 4.5,friends: data["members"].length,id: widget.groupId,days:data["days"]);
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

  MainContainer ({
    required this.id,
    required this.title,
    required this.image,
    required this.rating,
    required this.friends,
    required this.days
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

    var timeRangeList = widget.days.map((e) => DateTimeRange(
      start: (e["start"] as Timestamp).toDate(),
      end: (e["end"] as Timestamp).toDate()
    )).toList();

    timeRangeList.add(DateTimeRange(start: dateRange.start, end: dateRange.end));
    final Map<int, List<ComparingResult>> searchResults = findOverlap(ranges: timeRangeList);
    print(searchResults[widget.days.length+1]!.first.overlappingRange);
    

  //  await firestore.collection("groups").doc(widget.id).set({
  //    "available": {"start": time.start, "end":time.end}
  //  });

    setState(() {
      startDate = dateRange.start;
      endDate = dateRange.end;
    });
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
                                Container(margin: EdgeInsets.only(left: 5), child: Text("2 jam", textScaleFactor: 1.2, style: TextStyle(color: Colors.indigo[100]),),)
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
                              onPressed: () {
                                openDateRangeSelector(context);
                              },
                              child: Text("Plan yours", textScaleFactor: 1.4, style: TextStyle(color: kPrimaryColor),),
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