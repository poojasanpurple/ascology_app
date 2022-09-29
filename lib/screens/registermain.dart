import 'dart:async';

import 'package:ascology_app/screens/login.dart';
import 'package:ascology_app/screens/register.dart';
import 'package:ascology_app/utility/custom_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';




class RegisterMain extends StatefulWidget {

 // final String title;

 // const RegisterMain({Key key, this.title}) : super(key: key);


  @override
  _RegisterMainState createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  SharedPreferences logindata;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
  }


  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showDialogBox() => showCupertinoDialog<String>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('No Connection'),
      content: const Text('Please check your internet connectivity'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context, 'Cancel');
            setState(() => isAlertSet = false);
            isDeviceConnected =
            await InternetConnectionChecker().hasConnection;
            if (!isDeviceConnected && isAlertSet == false) {
              showDialogBox();
              setState(() => isAlertSet = true);
            }
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );


  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
        child: Scaffold(
            body: Flex(direction: Axis.vertical,
                children: [
                  Expanded(
                      child: Column(children: <Widget>[
                        Expanded(
                    child:
                        Container(

                          // margin: EdgeInsets.fromLTRB(0.0,0,0,20),
                            height: MediaQuery
                                .of(context)
                                .size
                                .height, // Also Including Tab-bar height.
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,

                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/bg_image_new.jpg"),
                                    fit: BoxFit.cover)),
                            child:SingleChildScrollView(
                              child:

                              /* Expanded(child:*/

                             Column(
                              mainAxisAlignment: MainAxisAlignment.start,

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //  alignment: Alignment.center,
                                  padding: EdgeInsets.all(65.0),
                                  child: Image.asset('assets/images/logo.png'),
                                ),

                        /* Flex( direction: Axis.horizontal,sG
            children: [*/
                      /*  Expanded(
                          flex: 1,
                          child:
                          //   Column(children: <Widget>[

                          Container(
                            color: Colors.white,
                            child: SingleChildScrollView(

                              child: Column(

                                mainAxisAlignment: MainAxisAlignment.center,

                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
*/

                                  GestureDetector(
                                    onTap : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Register()),
                                      );
                                      //print('do something');
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      margin: EdgeInsets.fromLTRB(
                                          50.0, 0, 50.0, 0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                          border: Border.all( width: 1,color: Colors.white),
                                          borderRadius: const BorderRadius.all(Radius.circular(40)),

                                       ), // button text
                                      child: Text("Create Account", style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: cf.Size.blockSizeHorizontal*3.5,
                                          color: Colors.black

                                      ),),
                                    ),
                                  ),

                                  SizedBox(height: 20),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(50.0, 0, 50.0, 0),
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 50,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()),
                                        );
                                      },
                                     // color: const Color(0xffe22525),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40),side: BorderSide(color: Colors.white)

                                      ),
                                      child: Text("Login", style: TextStyle(
                                          fontFamily: 'Poppins',
                                        fontSize: cf.Size.blockSizeHorizontal*3.5,
                                          color: Colors.white,

                                      ),),
                                    ),

                                  ),

                                  SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    child: FlatButton(
                                      child: Text("Need help ?", style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Poppins',
                                          fontSize: cf.Size.blockSizeHorizontal*3.5,
                                          color: Colors.white),),
                                      onPressed: () {
                                        // Navigator.pushReplacementNamed(context, '/login');
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);

                                      },
                                    ),
                                /*  ),


                                ],
                              ),

                            ),
                          ),

                        ),
*/
                                  ),

                                    ],
                                  )
                          //  ),
        ),

    ),),

                      ]
                      )
                  )
                ]
            )));
  }
}

