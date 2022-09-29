
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_forgetpasswd_request.dart';
import 'package:ascology_app/model/response/agent_forgtpasswd_response.dart';
import 'package:ascology_app/screens/agent_chng_passwd.dart';
import 'package:ascology_app/screens/agent_verify_otp.dart';
import 'package:ascology_app/screens/user_verify_otp.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AgentForgotPasswd extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentForgotPasswdState createState() => _AgentForgotPasswdState();
}

class _AgentForgotPasswdState extends State<AgentForgotPasswd> {

  final formKey = GlobalKey<FormState>();

  String agent_mobile;
  TextEditingController mobilecontroller = TextEditingController();
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Agent Forgot Password', style: TextStyle(
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
                  TextFormField(
                    autofocus: false,
                    //validator: validateEmail,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    onSaved: (value)=> agent_mobile = value,
                    controller: mobilecontroller,
                    decoration: buildInputDecoration('Enter mobile number',Icons.phone),
                  ),

                  SizedBox(height: 20.0,),

                  Container(
                    alignment: Alignment.center,
                    child : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xffe22525)),
                      child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w300),),
                      onPressed: ()
                      {
                        // Navigator.pushReplacementNamed(context, '/login');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);
                        agent_forgotpassword(context);

                      },
                    ),
                  ),



                  /*auth.loggedInStatus == Status.Authenticating
                      ?loading
                      : longButtons('Login',doLogin),
                  SizedBox(height: 8.0,),
                  forgotLabel*/

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void agent_forgotpassword(BuildContext context) async {

    agent_mobile = mobilecontroller.text;

    if (agent_mobile != null) {

      if (agent_mobile.length == 10) {
        //  loaderFun(context, true);
        var _loginApiClient = LoginApiClient();
        AgentForgetPasswdRequestModel forgetPasswdRequestModel = new AgentForgetPasswdRequestModel();
        forgetPasswdRequestModel.mobile = agent_mobile;

        AgentForgetPasswordResponseModel userModel = await _loginApiClient
            .agentforgotPassword(forgetPasswdRequestModel);
        print("!Q!Q!QQ!Q!Q!Q $userModel");
        if (userModel.status == true) {
          print('Password sent to email');

          Flushbar(
            title: ' ',
            message: 'Otp sent to registered mobile number' ,
            duration: Duration(seconds: 10),
          ).show(context);


         /* Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>  AgentVerifyOtp()),
                (Route<dynamic> route) => false,
          );
*/
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) {
                  return AgentVerifyOtp(mobile: agent_mobile);
                },
              ));


        }
        else {
          //  loaderFun(context, false);
          print('Invalid email id');
        }
      }


      else {
        print('Please enter valid mobile number');
      }
    }
    else {
      print('Please enter your mobile number');
    }

  }
}