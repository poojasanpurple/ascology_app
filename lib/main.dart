import 'dart:async';
import 'package:ascology_app/screens/agent_dashboard.dart';
import 'package:ascology_app/screens/agent_home.dart';
import 'package:ascology_app/screens/login.dart';
import 'package:ascology_app/screens/register.dart';
import 'package:ascology_app/screens/registermain.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
 // print(message.notification!.title);
}



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
//  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AstroAshram',


        theme: ThemeData(
          primaryColor: const Color(0xffe22525),
          primaryColorDark: const Color(0xffe22525),
          fontFamily: 'Poppins',
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
        ),

        /* routes: {
        '/login':(context)=>Login(),
        '/register':(context)=>Register(),
      },*/

        home: SplashScreen(),


      );

  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

//SharedPreferences sharedPreferences;

  SharedPreferences logindata;
  bool newuser;
  String session_usertype;
  bool _visible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTime();

    //check_if_already_login();
  }

  /*void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => UserHomePage()));
    }
  }
*/
  void startTime(){
    var duration = Duration(seconds: 5);
    //Timer(duration, gottoregistermain);
    Timer(duration, gotomain);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      /* Stack(
          children:<Widget> [*/

      Container(
          height: double.infinity,
          width: double.infinity,
          child:
          //Center(
          Image.asset(
            "assets/images/intro_logo.gif",

          )
        //)

      ),

      /* Container(
              height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.

              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              // child: getImage(),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/splashback.png'),
                      fit: BoxFit.cover
                  )),

            ),
            Container(
               alignment: Alignment.center,
              // padding: EdgeInsets.all(10.0),
              child: Image.asset('assets/images/logo.png'),
              padding: EdgeInsets.all(75.0),

            ),*/
      /*   ],
        ),

*/
    );
  }

  void gottoregistermain() {

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  RegisterMain()),
          (Route<dynamic> route) => false,
    );


  }

  Widget getImage()
  {
    AssetImage assetImage = AssetImage('assets/images/background1.png');
    Image image = Image(
      image: assetImage,
      width: 220.0,
      height: 120.0,
    );

    return Container(
      child: image,
    );


  }


  void initializeSharedPreferences() async{
    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_usertype = logindata.getString('user_type');

      if(session_usertype=="User")
      {

        /*  Navigator.pushReplacement(context,new MaterialPageRoute(builder:
      (context) => UserHomePage()));*/

        Navigator.pushReplacement(context,new MaterialPageRoute(builder:
            (context) => UserDashboard()));

      }
      else if(session_usertype=="Agent")
      {
        Navigator.pushReplacement(context,new MaterialPageRoute(builder:
            (context) => AgentHomePage()));

      }
      else
      {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  RegisterMain()),
              (Route<dynamic> route) => false,
        );

      }
    });

  }

  void gotomain () {

    initializeSharedPreferences();

  }
}
