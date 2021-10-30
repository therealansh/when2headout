import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel/constants.dart';
import 'package:travel/screens/home/components/top_travelers.dart';
import 'package:travel/screens/home/home_screen.dart';
import 'package:travel/services/google_sign_in.dart';
import 'package:travel/size_config.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height:size.height,
          width:size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/main_background.png'),
                  fit: BoxFit.fill)),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.2,
              ),
              Text(
                'when2headout',
                style: TextStyle(
                  color: Colors.white,
                    fontSize: getProportionateScreenWidth(32),
                    fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
              ),
              Text(
                'Plan your failed trips.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenWidth(18),
                    ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                width: getProportionateScreenWidth(250),
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white24, spreadRadius: 1, blurRadius: 1)
                    ]),
                child: GestureDetector(
                  onTap: ()async{
                    FirebaseService service = new FirebaseService();
                    try {
                      await service.signInwithGoogle().then((value) => {});
                      User? res = FirebaseAuth.instance.currentUser;
                      await firestore.collection('users').doc(res?.uid).get().then((val)=>{
                        if(val.exists){
                          // ignore: avoid_print
                          print("okay")
                        }else{
                          val.reference.set({
                            'name':res?.displayName,"uid":res?.uid,'image':res?.photoURL})
                        }
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                    } catch (e) {
                      print(e);
                    }
                    
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Sign in with Google",),
                      Icon(
                        Icons.chevron_right,
                        color: kPrimaryColor,
                        size: 28,
                      ),
                    ],
                  ),
                )

            )

            ]
          ),
        ),
        // Positioned(
        //     top: size.height * 0.25,
        //     child: Container(
        //       width: size.width,
        //       child: Text(
        //         "Discover the World",
        //         style: TextStyle(color: Colors.white, fontSize: 30),
        //         textAlign: TextAlign.center,
        //       ),
        //     )),
        // Positioned(
        //     bottom: size.height * 0.2,
        //     left: size.width * 0.05,
        //     child: Container(
        //       width: size.height * 0.9,
        //       child: Text(
        //         "We'll help you to find the best \n  experience & adventures",
        //         textAlign: TextAlign.center,
        //       ),
        //     )),
        // Positioned(
        //     bottom: size.height * 0.1,
        //     left: size.width * 0.43,
        //     child: Container(
        //         width: 60,
        //         height: 60,
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.all(Radius.circular(10)),
        //             boxShadow: [
        //               BoxShadow(
        //                   color: Colors.white24, spreadRadius: 1, blurRadius: 1)
        //             ]),
        //         child: GestureDetector(
        //           onTap: (){
        //             Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        //           },
        //           child: Icon(
        //             Icons.chevron_right,
        //             color: Color(0xFF03A2F5),
        //             size: 28,
        //           ),
        //         )

        //     )),
      ],
    ));
  }
}