import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:travel/models/places.dart';

import 'package:travel/models/TravelSpot.dart';
import 'package:travel/models/User.dart';

import '../constants.dart';
import '../size_config.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    Key? key,
    required this.travelSport,
    this.isFullCard = false,
    required this.press,
  }) : super(key: key);

  final Item travelSport;
  final bool isFullCard;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(isFullCard ? 158 : 137),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: isFullCard ? 1.09 : 1.29,
            child: Container(
              decoration:BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Red_Mountains.png"),
                  fit: BoxFit.cover,
                ),
              )
            ),
            // child: CachedNetworkImage(
            //   placeholder: (context,url)=>CircularProgressIndicator(),
            //   imageUrl: travelSport.image!.url!,
            //   imageBuilder: (context,imgProv) => Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(20),
            //       topRight: Radius.circular(20),
            //     ),
            //     image: DecorationImage(
            //         image: imgProv
            //   ),)
            // ),
            // )
          ),
          Container(
            width: getProportionateScreenWidth(isFullCard ? 158 : 137),
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
                  travelSport.name!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isFullCard ? 17 : 12,
                  ),
                ),
                if (isFullCard)
                  // Text(
                  //   travelSport.date!.day.toString(),
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline4!
                  //       .copyWith(fontWeight: FontWeight.bold),
                  // ),
                if (isFullCard)
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
}

class Travelers extends StatelessWidget {
  const Travelers({
    Key? key,
    required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    int totalUser = 0;
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenWidth(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
            users.length,
            (index) {
              totalUser++;
              return Positioned(
                left: (22 * index).toDouble(),
                child: buildTravelerFace(index),
              );
            },
          ),
          Positioned(
            left: (22 * totalUser).toDouble(),
            child: Container(
              height: getProportionateScreenWidth(28),
              width: getProportionateScreenWidth(28),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  ClipOval buildTravelerFace(int index) {
    return ClipOval(
      child: Image.asset(
        users[index].image!,
        height: getProportionateScreenWidth(28),
        width: getProportionateScreenWidth(28),
        fit: BoxFit.cover,
      ),
    );
  }
}
