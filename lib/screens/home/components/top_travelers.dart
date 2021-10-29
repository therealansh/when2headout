import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel/components/section_title.dart';
import 'package:travel/models/User.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class TopTravelers extends StatefulWidget {
  const TopTravelers({
    Key? key,
  }) : super(key: key);

  @override
  State<TopTravelers> createState() => _TopTravelersState();
}

class _TopTravelersState extends State<TopTravelers> {

  List<User> users = [];

  Future<List<User>> getUser() async {
    final users = await firestore.collection('users').get();      
    final List<User> userList = [];
    for (var user in users.docs) {
      userList.add(User.fromMap(user.data()));
    }
    return userList;
  }

  initState(){
    super.initState();
    getUser().then((value) => {
      setState(() {
        users = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    press: () {},
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.user,
    required this.press,
  }) : super(key: key);

  final User user;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: press,
        child: Column(
          children: [
            ClipOval(
              child: Image.network(
                user.image!,
                height: getProportionateScreenWidth(55),
                width: getProportionateScreenWidth(55),
                fit: BoxFit.cover,
              ),
            ),
            VerticalSpacing(of: 10),
            Text(
              user.name!.trim().split(" ")[0],
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
