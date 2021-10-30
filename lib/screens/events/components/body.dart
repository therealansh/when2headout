import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel/components/place_card.dart';
import 'package:travel/constants.dart';
import 'package:travel/models/TravelSpot.dart';
import 'package:travel/models/TravelSpot.dart';
import 'package:travel/models/groups.dart';
import 'package:travel/screens/destination/dest_screen.dart';
import 'package:travel/screens/home/components/top_travelers.dart';
import 'package:travel/screens/home/home_screen.dart';
import 'package:travel/size_config.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Widget placeCard(Map<String, dynamic> place,String id) {
    return GestureDetector(
      onTap: () => Navigator.push(context,MaterialPageRoute(builder:(context)=>MainContainer(days: place["days"], friends: place["members"].length, id: id, image: "assets/images/home_bg.png", rating: 4.5, title: place["name"], available:  DateTimeRange(start: (place["available"]["start"] as Timestamp).toDate(), end: (place["available"]["end"] as Timestamp).toDate()), isPlanned: true,))),
      child: SizedBox(
        height: getProportionateScreenHeight(250),
        width: getProportionateScreenWidth(158),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.09 ,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage("assets/images/Red_Mountains.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: getProportionateScreenWidth(158),
              padding: EdgeInsets.all(
                getProportionateScreenWidth(kDefaultPadding),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [kDefualtShadow],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    place["name"],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize:  17,
                    ),
                  ),
                  
                    // Text(
                    //   available.day.toString(),
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .headline4!
                    //       .copyWith(fontWeight: FontWeight.bold),
                    // ),
                    // Text(
                    //   DateFormat.MMMM().format(travelSport.date) +
                    //       " " +
                    //       travelSport.date!.year.toString(),
                    // ),
                  VerticalSpacing(of: 10),
                  // Travelers(
                  //   users: travelSport.,
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore.collection("groups").where("members", arrayContains: user?.uid).get(),
      builder: (context,snap){
        if (snap.hasError) {
          return Text("Something went wrong");
        }

        if (!snap.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if(snap.connectionState==ConnectionState.done){
          return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 25,
              children: [
                ...snap.data!.docs.map((doc)=>placeCard((doc.data()! as Map<String,dynamic>), doc.id)).toList(),
                AddNewPlaceCard(),
              ],
            ),
          ),
        ),
      ),
    );
        }
    return Center(child: CircularProgressIndicator(),);

      },
    );
  }
}

class AddNewPlaceCard extends StatelessWidget {
  const AddNewPlaceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenWidth(250),
      width: getProportionateScreenWidth(158),
      decoration: BoxDecoration(
        color: Color(0xFF6A6C93).withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Color(0xFFEBE8F6),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: getProportionateScreenWidth(53),
            width: getProportionateScreenWidth(53),
            child: FlatButton(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              color: kPrimaryColor,
              onPressed: () {},
              child: Icon(
                Icons.add,
                size: getProportionateScreenWidth(35),
                color: Colors.white,
              ),
            ),
          ),
          VerticalSpacing(of: 10),
          Text(
            "Add New Place",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
