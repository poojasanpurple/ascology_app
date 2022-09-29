
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_login_request.dart';
import 'package:ascology_app/model/response/agent_login_response.dart';
import 'package:ascology_app/screens/agent_forgtpasswd.dart';
import 'package:ascology_app/screens/agent_home.dart';
import 'package:ascology_app/screens/agent_register.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class AgentLogin extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentLoginState createState() => _AgentLoginState();
}

class _AgentLoginState extends State<AgentLogin> {

  final formKey = GlobalKey<FormState>();
  String agent_mobile, agent_password,agent_id,agent_extension,session_agent_mobile,session_agent_password,
  session_agent_fcmtoken;
  SharedPreferences logindata;
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  TextEditingController mobilenocontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String apkversion = '1.1';
  String deviceName = '';
  String device_model = '';
  String deviceVersion = '';
  String identifier = '';
  String token = '';
  String imei_number='';

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
        appBar: AppBar(
          title: Text('Agent Login', style: TextStyle(
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
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.0,),
                  TextFormField(
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                    autofocus: false,
                    //validator: validateEmail,
                    onSaved: (value)=> agent_mobile = value,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: mobilenocontroller,
                    decoration: buildInputDecoration('Enter mobile number',Icons.phone),
                  ),
                  SizedBox(height: 20.0,),

                  TextFormField(
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),
                    autofocus: false,
                    obscureText: true,
                    controller: passwordcontroller,
                    validator: (value)=> value.isEmpty?"Please enter password":null,
                    onSaved: (value)=> agent_password = value,
                    decoration: buildInputDecoration('Enter Password',Icons.lock),
                  ),
                  SizedBox(height: 20.0,),

                  Container(
                    alignment: Alignment.center,
                    child : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffe22525)),
                      child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3),),
                      onPressed: ()
                      {

                        agentlogin(context);
                        // Navigator.pushReplacementNamed(context, '/login');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);


                      },
                    ),
                  ),



                  SizedBox(height: 5.0,),

                  Container(
                    alignment: Alignment.center,
                    child : FlatButton(
                      child: Text("Forgot password ?",style: TextStyle(fontWeight: FontWeight.w300,color: const Color(0xffe22525),fontSize: cf.Size.blockSizeHorizontal * 3,),),
                      onPressed: ()
                      {

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) =>  AgentForgotPasswd()),
                              (Route<dynamic> route) => false,
                        );
                        // Navigator.pushReplacementNamed(context, '/login');
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);

                      },
                    ),
                  ),

                  SizedBox(height: 5.0,),

                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child:RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Create an account? ',
                          style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.8,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            text: 'Agent SignUp',
                            style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.8,
                              color: const Color(0xffe22525),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  Agent_Register()),
                                );
                              }),
                      ]),
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

  void agentlogin(BuildContext context) async{

    logindata = await SharedPreferences.getInstance();
    agent_mobile = mobilenocontroller.text;
    agent_password = passwordcontroller.text;
    String fcmtoken = await FirebaseMessaging.instance.getToken();
    print(fcmtoken);
    if(agent_mobile != null){

      if(agent_mobile.length == 10){
        if(agent_password != null) {
          //  loaderFun(context, true);
          var _loginApiClient = LoginApiClient();
          AgentLoginRequestModel loginRequestModel = new AgentLoginRequestModel();
          loginRequestModel.phone = agent_mobile;
          loginRequestModel.password = agent_password;
          loginRequestModel.token = fcmtoken;
          loginRequestModel.device_name = '';
          loginRequestModel.device_model = '';
          loginRequestModel.apk_version = apkversion;
          loginRequestModel.imei_number = '';

          AgentLoginResponseModel userModel = await _loginApiClient.agentlogin(loginRequestModel);
          print("!Q!Q!QQ!Q!Q!Q $userModel");
          if(userModel.status == true){
         /*   print('status'+userModel.status.toString());
            print('Agent Login successful');
*/
            Fluttertoast.showToast(
                msg: "Login successful...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            );
            agent_id = userModel.agent_id;
            agent_extension = userModel.extension;
            session_agent_mobile = userModel.mobile;
            session_agent_password = userModel.password;
            session_agent_fcmtoken = userModel.token;

            print('Agent_id'+agent_id);
            logindata.setBool('agentlogin', false);
            logindata.setString('agent_id', agent_id);

            logindata.setString('user_type', "Agent");
            logindata.setString('agent_ext', agent_extension);
            logindata.setString('agent_mobile', session_agent_mobile);
            logindata.setString('agent_password', session_agent_password);
            logindata.setString('agent_fcmtoken', session_agent_fcmtoken);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  AgentHomePage()),
            );

          }
          else
          {
            //  loaderFun(context, false);
            Fluttertoast.showToast(
                msg: "Invalid login details...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            );

            print('Account does not exist');
          }
        }
        else{
          print('Please enter your password.');
        }
      }
      else{
        print('Please enter valid mobile no.');
      }
    }
    else{
      print('Please enter your Email Id.');
    }

  }
}