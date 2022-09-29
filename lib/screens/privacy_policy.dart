
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';


class PrivPolicyPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _PrivPolicyPageState createState() => _PrivPolicyPageState();
}

class _PrivPolicyPageState extends State<PrivPolicyPage> {

  String data_title,data_img,data_sec_img;
  var data_short_desc,data_desc;
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getConnectivity();
   // fetch_priv_policy();
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
        appBar: AppBar(
          title: Text('Privacy Policy', style: TextStyle(
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
          Container(
            margin: EdgeInsets.fromLTRB(20,20, 20, 20),
              width: cf.Size.screenWidth,
              height: cf.Size.screenHeight,
            child:

            Column(
                children: [
                  Text.rich(
                      TextSpan(
                          style: TextStyle(fontSize: 27,),
                          children: [
                            TextSpan(
                                text: "By continuing, you agree to our ",style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize:  cf.Size.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight
                                    .w600,
                                color:  Colors.blueGrey
                            ),
                            ),
                            TextSpan(
                                style: TextStyle(color: Colors.red, decoration: TextDecoration.underline, fontFamily: 'Poppins',
                                  fontSize:  cf.Size.blockSizeHorizontal * 4.5,
                                  fontWeight: FontWeight
                                      .w600),
                                //make link blue and underline
                                text: "Terms of Service",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    //on tap code here, you can navigate to other page or URL
                                    String url = "https://astroashram.com/terms-of-use";
                                    var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                                    if(urllaunchable){
                                      await launch(url); //launch is from url_launcher package to launch URL
                                    }else{
                                      print("URL can't be launched.");
                                    }
                                  }
                            ),


                            TextSpan(
                                text: " and ",style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize:  cf.Size.blockSizeHorizontal * 4.5,
                                fontWeight: FontWeight
                                    .w600,
                                color:  Colors.blueGrey
                            ),
                            ),

                            TextSpan(
                                style: TextStyle(color: Colors.red, decoration: TextDecoration.underline, fontFamily: 'Poppins',
                                  fontSize:  cf.Size.blockSizeHorizontal * 4.5,
                                  fontWeight: FontWeight
                                      .w600,),
                                //make link blue and underline
                                text: "Privacy Policy",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    //on tap code here, you can navigate to other page or URL
                                    String url = "https://astroashram.com/privacy-policy";
                                    var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
                                    if(urllaunchable){
                                      await launch(url); //launch is from url_launcher package to launch URL
                                    }else{
                                      print("URL can't be launched.");
                                    }
                                  }
                            ),

                          ]
                      )
                  ),

                ]
            )

            /*Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/4,
                    child:
                    Html(data:data_short_desc),

                    *//*AutoSizeText(
                      Html(data:data_short_desc),
                      style: TextStyle(fontSize: 20),
                      //maxLines: 2,
                    ),*//*
                  ),


                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/2,
                    child:
                    Html(data:data_desc),

                    *//*AutoSizeText(
                      Html(data:data_short_desc),
                      style: TextStyle(fontSize: 20),
                      //maxLines: 2,
                    ),*//*
                  ),

                ],
              ),
            ),*/
          ),

      ),
    );




  }

  Future<void> fetch_priv_policy() async {
    var _loginApiClient = LoginApiClient();
    DataRequestModel dataRequestModel = DataRequestModel();
    dataRequestModel.slug = "privacy-policy";

    DataResponseModel userModel =
    await _loginApiClient.getstaticdetails(dataRequestModel);

    print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (userModel.status == true) {
      print(userModel.data);

      data_title = userModel.data[0].title.toString();
      data_short_desc = userModel.data[0].short_description.toString();
      data_desc = userModel.data[0].description.toString();

    }
    else {
      print(userModel.message);
    }



  }
}
