
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ReferEarnPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _ReferEarnPageState createState() => _ReferEarnPageState();
}

class _ReferEarnPageState extends State<ReferEarnPage> {

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
  Widget build(BuildContext context) {
    return SafeArea(
      child:
      Scaffold(
          resizeToAvoidBottomInset:false,
          appBar:AppBar(
            title: Text('Refer & Earn', style: TextStyle(
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

          Text('Refer & Earn')
        /*
        SingleChildScrollView(
          child:






        ),
*/



      ),
    );

  }


}
