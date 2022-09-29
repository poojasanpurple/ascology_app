
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class TermsConditionPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _TermsConditionPageState createState() => _TermsConditionPageState();
}

class _TermsConditionPageState extends State<TermsConditionPage> {

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
    fetch_terms();
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
        appBar: AppBar(
          title: Text('Terms and Conditions', style: TextStyle(
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
        body:SingleChildScrollView(
          child:
          Container(
            margin: EdgeInsets.fromLTRB(20,20, 20, 20),
            height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.
            width: MediaQuery.of(context).size.width,
            child:

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/4,
                    child:
                    Html(data:data_short_desc),

                    /*AutoSizeText(
                      Html(data:data_short_desc),
                      style: TextStyle(fontSize: 20),
                      //maxLines: 2,
                    ),*/
                  ),


                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/2,
                    child:
                    Html(data:data_desc),

                    /*AutoSizeText(
                      Html(data:data_short_desc),
                      style: TextStyle(fontSize: 20),
                      //maxLines: 2,
                    ),*/
                  ),

                ],
              ),
            ),
          ),





        ),




      ),
    );




  }

  Future<void> fetch_terms() async {
    var _loginApiClient = LoginApiClient();
    DataRequestModel dataRequestModel = DataRequestModel();
    dataRequestModel.slug = "terms-of-use";

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
