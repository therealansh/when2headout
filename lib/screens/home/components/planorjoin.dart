import 'package:flutter/material.dart';
import 'package:travel/components/section_title.dart';
import 'package:travel/constants.dart';
import 'package:travel/screens/Plan/plan.dart';
import 'package:travel/screens/home/home_screen.dart';
import 'package:travel/size_config.dart';

class PlanOrJoin extends StatelessWidget {
  const PlanOrJoin({ Key? key }) : super(key: key);

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