import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel/components/section_title.dart';
import 'package:travel/models/User.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class UserCard extends StatefulWidget {
  const UserCard({
    Key? key,
    required this.user,
    required this.press,
  }) : super(key: key);

  final UserModel user;
  final GestureTapCallback press;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: (){
          setState((){
            isSelected = !isSelected;
          });
          widget.press();
        },
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? kPrimaryColor : Colors.white,
              radius: getProportionateScreenWidth(38),
              child: ClipOval(
                child: Image.network(
                  widget.user.image!,
                  height: getProportionateScreenWidth(55),
                  width: getProportionateScreenWidth(55),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            VerticalSpacing(of: 10),
            Text(
              widget.user.name!.trim().split(" ")[0],
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
