// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel/components/section_title.dart';
import 'package:travel/constants.dart';
import 'package:travel/models/User.dart';
import 'package:travel/screens/home/components/top_travelers.dart';
import 'package:travel/size_config.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 99, kToday.month, kToday.day);

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key, this.user}) : super(key: key);
  final User? user;
  @override
  _PlanPageState createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {

  final TextEditingController _place = TextEditingController();
  
  Container textField() => Container(
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
                        controller: _place,
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

  List<UserModel> _selectedFriends = [];
  List<UserModel> users = [];

  Future<List<UserModel>> getUser() async {
    final users = await firestore.collection('users').get();
    final List<UserModel> userList = [];
    for (var user in users.docs) {
      UserModel userModel = UserModel.fromMap(user.data());
      if(userModel.uid == widget.user?.uid) continue;
      userList.add(UserModel.fromMap(user.data()));
    }
    return userList;
  }

  initState() {
    super.initState();
    getUser().then((value) => {
          setState(() {
            users = value;
          })
        });
  }

  Future<bool?> postGroup() async {
    if (_selectedDays.length != 2 || 
        _place.text.isEmpty) {
      return false;
    } else {
      _selectedFriends.add(UserModel(
        name: widget.user?.displayName,
        image: widget.user?.photoURL,
        uid: widget.user?.uid,
      ));
      try {
        final group = await firestore.collection('groups').add({
          'name': _place.text,
          'members': _selectedFriends.map((user) => user.uid).toList(),
          'days':[{'start':_selectedDays.first, 'end':_selectedDays.last}],
          "available":{'start':_selectedDays.first, 'end':_selectedDays.last},
        }).then((value) => true);
      } catch (e) {
        print(e);
        return false;
      }
    }
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
            textField(),
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
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(kDefaultPadding),
                  ),
                  padding: EdgeInsets.all(getProportionateScreenWidth(24)),
                  // height: getProportionateScreenWidth(143),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [kDefualtShadow],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...List.generate(
                          users.length,
                          (index) => UserCard(
                            user: users[index],
                            press: () {
                              if (_selectedFriends!.contains(users[index])) {
                                _selectedFriends!.remove(users[index]);
                              } else {
                                _selectedFriends!.add(users[index]);
                              }
                              print(_selectedFriends);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
                onTap: () {
                  postGroup();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
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
                )),
          ]),
    ));
  }
}
