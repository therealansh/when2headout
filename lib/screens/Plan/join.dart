import 'package:flutter/material.dart';
import 'package:travel/constants.dart';
import 'package:travel/size_config.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({ Key? key }) : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

  final TextEditingController _groupID = TextEditingController();

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
                        controller: _groupID,
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

      void _modalBottomSheetMenu(){
        showModalBottomSheet(
            context: context,
            builder: (builder){
              return new Container(
                height: 350.0,
                color: Colors.transparent, //could change this to Color(0xFF737373), 
                           //so you don't have to change MaterialApp canvasColor
                child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    child: new Center(
                      child: new Text("This is a modal sheet"),
                    )),
              );
            }
        );
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
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
                            'Join',
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
            Expanded(
              child: Center(
                child: Container(
                  height: SizeConfig.screenHeight! * 0.5,
                  padding: EdgeInsets.all(20),
                  child:Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Join your friends to explore the world',
                            style: TextStyle(
                              fontSize: getProportionateScreenHeight(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textField()
                        ])
                    ),
                  ),
                ),
              )
            )
        ]
      ),
    );
  }
}