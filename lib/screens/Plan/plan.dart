// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel/components/section_title.dart';
import 'package:travel/constants.dart';
import 'package:travel/screens/home/components/top_travelers.dart';
import 'package:travel/size_config.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 99, kToday.month, kToday.day);

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  Container textField = Container(
    margin: EdgeInsets.all(15.0),
    height: 61,
    child: Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35.0),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3), blurRadius: 5, color: Colors.grey)
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Search a place...",
                        hintStyle: TextStyle(color: kPrimaryColor),
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 15),
        Container(
          padding: const EdgeInsets.all(15.0),
          decoration:
              BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
          child: InkWell(
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onTap: () {},
          ),
        )
      ],
    ),
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  Container popularPlaces = Container(
    height: getProportionateScreenHeight(230),
    margin: EdgeInsets.symmetric(horizontal: 18),
    child: Stack(children: [
      Positioned(
        top: getProportionateScreenHeight(30),
        child: Material(
          child: Container(
              height: getProportionateScreenHeight(180),
              width: SizeConfig.screenWidth! * 0.9,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: Offset(-10.0, 10.0),
                        blurRadius: 20.0,
                        spreadRadius: 4.0)
                  ])),
        ),
      ),
      Positioned(
        top: 0,
        left: 35,
        child: Card(
            elevation: 10.0,
            shadowColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: getProportionateScreenHeight(180),
              width: getProportionateScreenWidth(150),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/Red_Mountains.png'))),
            )),
      ),
      Positioned(
        top: 45,
        left: 200,
        child: Container(
            height: getProportionateScreenHeight(150),
            width: getProportionateScreenWidth(160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Red Mountains",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Text(
                  "Location",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Colors.black,
                ),
                Text(
                  "Descp",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
      )
    ]),
  );

  Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });
    print(_selectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.screenHeight! * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                  color: kPrimaryColor),
              child: Stack(children: [
                Positioned(
                  top: SizeConfig.screenHeight! * 0.05,
                  left: SizeConfig.screenWidth! * 0.05,
                  child: const BackButton(
                    color: Colors.white,
                  ),
                ),
                Positioned(
                    top: SizeConfig.screenHeight! * 0.113,
                    left: 0,
                    child: Container(
                        child: Center(
                          child: Text(
                            'Plan Your Next Trip',
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(26),
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        height: 60,
                        width: SizeConfig.screenWidth! * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ))),
              ]),
            ),
            textField,
            //TODO add a listview or scrollview
            // popularPlaces,
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: _focusedDay,
              lastDay: kLastDay,
              selectedDayPredicate: (day) {
                return _selectedDays.contains(day);
              },
              onDaySelected: _onDaySelected,
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            SectionTitle(title: "Add your Friends", press: () => {}),
            TopTravelers(),
            SizedBox(height: 20),
            GestureDetector(
                onTap: () {
                 
                },
                child: Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color:kPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                    
                    ),
                  child: Text(
                        "Plan is ONNNNN!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                )
              ),
          ]),
    ));
  }
}
