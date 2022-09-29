
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

class AboutUsPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  
  String data_title,data_img,data_sec_img;
  String data_short_desc,data_desc;

  bool isLoading = false;

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

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
    fetch_about_us(context);
    return SafeArea(
      child:
      Scaffold(
        resizeToAvoidBottomInset:false,
        appBar: AppBar(
          title: Text('About Us', style: TextStyle(
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
           margin: EdgeInsets.fromLTRB(10,20, 10, 20),
              height: MediaQuery.of(context).size.height,  // Also Including Tab-bar height.
            width: MediaQuery.of(context).size.width,
            child:

            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width/1.1,
                          height: MediaQuery.of(context).size.height/4,
                          child:
                          Html(data:data_short_desc),

                          /*AutoSizeText(
                      Html(data:data_short_desc),
                      style: TextStyle(fontSize: 20),
                      //maxLines: 2,
                    ),*/
                        ),



                      ]
                  ),

                  SizedBox(height: 10),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget>[

                        Container(
                          width: MediaQuery.of(context).size.width/1.1,
                          height: MediaQuery.of(context).size.height/2,
                          child:
                          Html(data:data_desc),
//  flutter_html: ^0.8.2
                          /*AutoSizeText(
                      Html(data:data_short_desc),
                      style: TextStyle(fontSize: 20),
                      //maxLines: 2,
                    ),*/
                        ),
                      ]
                  ),




                ],
              ),
            ),
          ),





        ),




      ),
    );

  }

  void fetch_about_us(BuildContext context) async {

    setState(() {
      isLoading = true;
    });
    var _loginApiClient = LoginApiClient();
    DataRequestModel dataRequestModel = DataRequestModel();
    dataRequestModel.slug = "about-us";

    DataResponseModel userModel =
        await _loginApiClient.getstaticdetails(dataRequestModel);

    print("!Q!Q!QQ!Q!Q!Q ${userModel.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (userModel.status = true) {
      print(userModel.data);
      setState(() {
        isLoading = false;
      });
      //about us image
      // https://astroashram.com/uploads/cms_page/441b911b85b62506d4c9208731dfbd24.png
      data_title = userModel.data[0].title.toString();
      data_short_desc = userModel.data[0].short_description.toString();
      data_desc = userModel.data[0].description.toString();

    }
    else {
      isLoading = false;
      print(userModel.message);
    }
  }
  }
