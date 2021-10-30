import 'package:flutter/material.dart';
import 'package:travel/components/section_title.dart';
import 'package:travel/constants.dart';
import 'package:travel/screens/Plan/join.dart';
import 'package:travel/screens/Plan/plan.dart';
import 'package:travel/screens/destination/dest_screen.dart';
import 'package:travel/screens/home/home_screen.dart';
import 'package:travel/size_config.dart';

class PlanOrJoin extends StatelessWidget {
  PlanOrJoin({ Key? key }) : super(key: key);


  final TextEditingController _groupID = TextEditingController();

    Container textField(context) => Container(
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
                        controller: _groupID,
                        decoration: InputDecoration(
                            hintText: "Enter the Group ID...",
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
                onTap: () {
                  print(_groupID.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationScreen(
                        groupId: _groupID.text.isEmpty ? "0" : _groupID.text,
                      ),
                    ),
                  );
                },
              
              ),
            )
          ],
        ),
      );


    void _modalBottomSheetMenu(context){
        showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
            context: context,
            builder: (builder){
              return SingleChildScrollView(
                child: Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: new Container(
                    height: getProportionateScreenHeight(450),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(20.0),
                              topRight: const Radius.circular(20.0))),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          SizedBox(height: getProportionateScreenHeight(40)),
                          Text(
                            'Join your friends to explore the world',
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          textField(context),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/current.png'),
                              )),
                              width: getProportionateScreenWidth(200),
                              height: getProportionateScreenHeight(200),
                            ),
                        ]
                      )),
                ),
              );
            }
        );
      }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Text(
            "Plan Your Next Trip With Us.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(18),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PlanPage(user: user,)));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: getProportionateScreenWidth(120),
                  decoration: BoxDecoration(
                    color:kPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                    
                    ),
                  child: Text(
                        "Plan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                )
              ),
          const SizedBox(height: 16),
          GestureDetector(
                onTap: () {
                  _modalBottomSheetMenu(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>JoinPage()));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: getProportionateScreenWidth(120),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                    ),
                  child: Text(
                        "Join",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:kPrimaryColor,
                          fontSize: getProportionateScreenWidth(16),
                        ),
                      ),
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}