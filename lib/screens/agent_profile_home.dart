
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/screens/agent_profile.dart';
import 'package:ascology_app/screens/agent_upload_video.dart';
import 'package:ascology_app/screens/birth_details.dart';
import 'package:ascology_app/screens/match_making.dart';
import 'package:ascology_app/screens/upload_gallery_images.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AgentProfileHome extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _AgentProfileHomeState createState() => _AgentProfileHomeState();
}

class _AgentProfileHomeState extends State<AgentProfileHome> {

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
    return SafeArea(
      child:
      Scaffold(
          resizeToAvoidBottomInset:false,
          appBar:  AppBar(
            title: Text('Profile', style: TextStyle(
                color: Colors.white,
                fontSize: 22
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
                    title:Text("My Profile") ,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AgentProfile()),
                      );
                    },
                  )
              ),

              Card(
                child: ListTile(
                  title: Text("Upload photos"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AgentUploadImages()),
                    );

                  },
                ),
              ),
              Card(
                  child: ListTile(
                    title: Text("Upload Youtube video"),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AgentUploadVideo()),
                      );


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
