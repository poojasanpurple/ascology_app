
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/screens/birth_details.dart';
import 'package:ascology_app/screens/match_making.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:internet_connection_checker/internet_connection_checker.dart';


class HoroscopePage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _HoroscopePageState createState() => _HoroscopePageState();
}

class _HoroscopePageState extends State<HoroscopePage> {

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
    return SafeArea(
      child:
      Scaffold(
          resizeToAvoidBottomInset:false,
          appBar:  AppBar(
            title: Text('Horoscope', style: TextStyle(
                color: Colors.white,
                fontSize: cf.Size.blockSizeHorizontal * 4,
            ),) ,

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
                    title:Text('Birth Details', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BirthDetails()),
                      );
                    },
                  )
              ),
              Card(
                child: ListTile(
                  title: Text('Match Making', style: TextStyle(
                    fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                  ),) ,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MatchMakingPage()),
                    );
                  },
                ),
              ),
              Card(
                  child: ListTile(
                    title: Text('Horoscope Predictions', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,

                    onTap: () {

                    },
                  )
              ),

              Card(
                  child: ListTile(
                    title: Text('Daily Horoscope', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {

                    },
                  )
              ),

              Card(
                  child: ListTile(
                    title: Text('Free Kundali', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {

                    },
                  )
              ),

              Card(
                  child: ListTile(
                    title: Text('Compatibility', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {

                    },
                  )
              ),

              Card(
                  child: ListTile(
                    title: Text('Panchang', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {

                    },
                  )
              ),

              Card(
                  child: ListTile(
                    title: Text('Baby Names', style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
                    ),) ,
                    onTap: () {

                    },
                  )
              ),

              Card(
                  child: ListTile(
                    title: Text('Spiritual', style: TextStyle(
    fontSize: cf.Size.blockSizeHorizontal * 3.3, fontFamily: 'Poppins',
    ),) ,
                    onTap: () {

                    },
                  )
              ),
            ],
            shrinkWrap: true,
          )



      ),
    );

  }


}
