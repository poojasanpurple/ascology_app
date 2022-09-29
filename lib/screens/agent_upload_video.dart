
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_video_request.dart';
import 'package:ascology_app/model/request/forget_passwd_request.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/user_verify_otp.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentUploadVideo extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentUploadVideoState createState() => _AgentUploadVideoState();
}

class _AgentUploadVideoState extends State<AgentUploadVideo> {

  final formKey = GlobalKey<FormState>();
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  SharedPreferences logindata;
  String youtube_url,session_agent_id;
  TextEditingController urlcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    submitvideourl(context);

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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Video', style: TextStyle(
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.0,),
              Text(
                "https://www.youtube.com/watch?v=t0Q2otsqC4I"),
                  SizedBox(height: 10.0,),

                  TextFormField(
                    autofocus: false,
                    //validator: validateEmail,
                    controller: urlcontroller,
                    onSaved: (value) => youtube_url = value,
                    decoration: buildInputDecoration(
                        't0Q2otsqC4I', Icons.link),
                  ),

                  SizedBox(height: 20.0,),

                  Container(
                    alignment: Alignment.center,
                    child: /*ElevatedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(fontWeight: FontWeight.w300),),
                      onPressed: () {
                        submitvideourl(context);


                      },
                    ),*/

                      ElevatedButton(
                          style:
                      ElevatedButton.styleFrom(
                          primary: const Color(0xffe22525), //background color of button
                          side: BorderSide(width:4, color:const Color(0xffe22525)), //border width and color
                          elevation: 3, //elevation of button
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(20)
                          ),
                          padding: EdgeInsets.all(20) //content padding inside button
                      ),
                      onPressed: (){
                        //code to execute when this button is pressed.
                      },
                      child: Text("Submit")
                  )

                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submitvideourl(BuildContext context) async {
    youtube_url = urlcontroller.text;

    logindata = await SharedPreferences.getInstance();
    session_agent_id = logindata.getString('agent_id');

    //  loaderFun(context, true);
    var _loginApiClient = LoginApiClient();
    AgentVideoRequestModel forgetPasswdRequestModel = new AgentVideoRequestModel();
    forgetPasswdRequestModel.agent_id = session_agent_id;

    UserChangePasswordResponseModel userModel = await _loginApiClient
        .uploadvideo(forgetPasswdRequestModel);
    print("!Q!Q!QQ!Q!Q!Q $userModel");
    if (userModel.status == true) {
      print('Password sent to mobile number');

      Fluttertoast.showToast(
          msg: "Video uploaded successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
    else {
      //  loaderFun(context, false);
      print('Invalid mobile number');
    }


  }
}
