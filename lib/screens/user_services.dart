
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/screens/astrologer_numerology.dart';
import 'package:ascology_app/screens/astrologer_psychology.dart';
import 'package:ascology_app/screens/astrologer_tarot.dart';
import 'package:ascology_app/screens/astrologers.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ServicesPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  const ServicesPage({Key key}) : super(key: key);

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetch_about_us(context);
  }*/

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
    return WillPopScope(
        onWillPop: () async {
      /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The System Back Button is Deactivated')));*/
      return false;
    },
    child:
    SafeArea(
      child:
      Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Services', style: TextStyle(
                color: Colors.white,
                fontSize: cf.Size.blockSizeHorizontal * 4,
            ),) ,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
               /* Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomePage()),
                );*/

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserDashboard()),
                );
              },
            ),

            flexibleSpace: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/getnow.png'),
                      fit: BoxFit.fill
                  )
              ),
            ),

          ),

          body:

          ListView(
            padding: EdgeInsets.all(10),
            children: [
              Card(
                  child: ListTile(
                    title: Text('Mental Wellness', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Astrologers_PsychoPage()),
                      );
                    },
                  )
              ),
              Card(
                child: ListTile(
                  title: Text('Numerology', style: TextStyle(
                    fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                  ),) ,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Astrologers_NumeroPage()),
                    );
                  },
                ),
              ),
              Card(
                  child: ListTile(
                      title: Text('Astrology', style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                      ),) ,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AstrologersPage()),
                        );
                      }


                  )
              ),

              Card(
                  child: ListTile(
                    title: Text('Tarot Card', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Astrologers_TarotPage()),
                      );
                    },
                  )
              ),


            ],
            shrinkWrap: true,
          )


      ),
    )
    );
  }
}
