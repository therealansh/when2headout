import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel/components/place_card.dart';
import 'package:travel/components/section_title.dart';
import 'package:travel/models/places.dart';
import 'package:travel/models/TravelSpot.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../size_config.dart';

class PopularPlaces extends StatefulWidget {
  const PopularPlaces();

  @override
  State<PopularPlaces> createState() => _PopularPlacesState();
}

class _PopularPlacesState extends State<PopularPlaces> {
  
  Future<Places> getCities()async{
    var responseJson;
    final response = await http.get(Uri.parse("https://www.headout.com/api/public/v1/city?offset=34&limit=253"));
    return Places.fromJson(json.decode(response.body));
  }

  List<Item> items = [];

  @override
  void initState() {
    getCities().then((value) {
      print(value.items.length);
      setState(() {
        items = value.items;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle( 
          title: "Right Now At Spark",
          press: () {},
        ),
        VerticalSpacing(of: 20),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...items.map((e) => PlaceCard(
                    travelSport: e,
                    press: () {},
                  )).take(5),
              SizedBox(
                width: getProportionateScreenWidth(kDefaultPadding),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
