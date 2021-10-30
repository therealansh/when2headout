import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travel/components/place_card.dart';
import 'package:travel/constants.dart';
import 'package:travel/models/TravelSpot.dart';
import 'package:travel/models/TravelSpot.dart';
import 'package:travel/models/groups.dart';
import 'package:travel/screens/home/components/top_travelers.dart';
import 'package:travel/size_config.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Group> groups = [];

  Future<List<Group>> getGroups() async {
    var value = await firestore.collection("groups").get();
    List<Group> groups = [];
      for (int i = 0; i < value.docs.length; i++) {
        groups.add(Group.fromMap(value.docs[i].data()));
      }
      return groups;
  }

  SizedBox placeCard(String name){
    return SizedBox(
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
                  name,
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
    );
  }

  @override
  initState(){
    getGroups().then((value) {
      setState(() {
        groups = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
                ...List.generate(
                  groups.length,
                  (index) => placeCard(groups[index].name!),
                ),
                AddNewPlaceCard(),
              ],
            ),
          ),
        ),
      ),
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
      height: getProportionateScreenWidth(350),
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
