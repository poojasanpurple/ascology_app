
import 'dart:async';
import 'dart:io';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/NotifySendRequest.dart';
import 'package:ascology_app/model/request/chat_send_request.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/response/user_chngpasswd_response.dart';

class UserChatWebview extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  String chat_agent_id,chat_user_id,chat_agent_name,chat_agent_img,chat_agent_price,chat_fcm_token;

  UserChatWebview({this.chat_agent_id,this.chat_fcm_token});

  @override
  _UserChatWebviewState createState() => _UserChatWebviewState();
}

class _UserChatWebviewState extends State<UserChatWebview> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  String send_agent_id,session_user_id,chat_msg,send_fcm_token;
  SharedPreferences logindata;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  TextEditingController msgboxcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    send_agent_id = widget.chat_agent_id;
    send_fcm_token = widget.chat_fcm_token;
   // print('hiiiii'+send_agent_id);
    getsessionuser_id();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

  }

  void send_notification(BuildContext context) async{

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_user_id = logindata.getString('user_id');
      print('session_userid'+session_user_id);
    });

    // UserForgetPasswordResponseModel

    var _loginApiClient = LoginApiClient();
    NotifySendRequestModel chatSendRequestModel = new NotifySendRequestModel();

    chatSendRequestModel.agent_id = send_agent_id;
    print(send_agent_id);
    print(session_user_id);
    chatSendRequestModel.user_id = session_user_id;
    chatSendRequestModel.token = send_fcm_token;

    UserChangePasswordResponseModel registerResModel = await _loginApiClient.send_notification(chatSendRequestModel);

    if(registerResModel.status == true){

      Fluttertoast.showToast(
          msg: registerResModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      // openSubscriptionPage(context, registerResModel);

      /*  Flushbar(
                     // title: 'Invalid form',
                      message: registerResModel.message,
                      duration: Duration(seconds: 5),
                    ).show(context);
*/
      //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);

    }
    else{
      //loaderFun(context, false);
      //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Unable to create account.')));

      Fluttertoast.showToast(
          msg: registerResModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      // Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);

    }


  }

  void sendmsgtoagent(BuildContext context) async{

    chat_msg = msgboxcontroller.text;
    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_user_id = logindata.getString('user_id');
    });

    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");
    if(chat_msg != null && chat_msg != ""){

      var _loginApiClient = LoginApiClient();
      ChatSendRequestModel chatSendRequestModel = new ChatSendRequestModel();

      chatSendRequestModel.agent_id = send_agent_id;
      print(send_agent_id);
      print(session_user_id);
      chatSendRequestModel.user_id = session_user_id;
      chatSendRequestModel.msgText = chat_msg;
      chatSendRequestModel.chat_from = "user";
      chatSendRequestModel.chat_to = "agent";

      UserChangePasswordResponseModel registerResModel = await _loginApiClient.sendmsgtoagent(chatSendRequestModel);

      if(registerResModel.status == true){

        Fluttertoast.showToast(
            msg: registerResModel.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

        msgboxcontroller.text = '';

        send_notification(context);

       // this.getchatlist(context);
        // openSubscriptionPage(context, registerResModel);

        /*  Flushbar(
                      // title: 'Invalid form',
                      message: registerResModel.message,
                      duration: Duration(seconds: 5),
                    ).show(context);
*/
        //   Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);

      }
      else{
        //loaderFun(context, false);
        //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Unable to create account.')));

        Fluttertoast.showToast(
            msg: registerResModel.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

        // Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);

      }

    }
    else{
      Fluttertoast.showToast(
          msg: "Please enter your message...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      /*loaderFun(context, false);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter your full name')));*/
    }
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
  void getsessionuser_id() async {
  logindata = await SharedPreferences.getInstance();
  setState(() {
  session_user_id = logindata.getString('user_id');
 /* Fluttertoast.showToast(
      msg: session_user_id,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );*/

  });
}


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Welcome to Flutter',
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          /*appBar: AppBar(
            title: Text('Welcome to Flutter'),89i
          ),*/
          body:


         /* Builder(builder: (BuildContext context) {
*/
         //   return


              Stack(
                children: <Widget>[

                  WebView(
              initialUrl: 'https://astroashram.com/app_login?redirect_to=user&agentid='+send_agent_id+'&userid='+session_user_id,
              javascriptMode: JavascriptMode.unrestricted,
              zoomEnabled: false,
              gestureNavigationEnabled: true,
                   // userAgent: "random",

              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) async {
                print('onPageStarted reports URL: $url');
                print("Actual url (onPageStarted): ${await (await _controller.future).currentUrl()}");
              },
              onPageFinished: (String url) async {
                print('onPageFinished reports URL: $url');
                print("Actual url (onPageFinished): ${await (await _controller.future).currentUrl()}");
              },
              navigationDelegate: (NavigationRequest request) {
                if(request.url == ('https://astroashram.com/common_end_chat/end')) {

                  Navigator.pop(context);

                  Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UserDashboard() ;
                        },
                      ));
                  //You can do anything

                  //Prevent that url works
                  return NavigationDecision.prevent;
                }
                //Any other url works
                return NavigationDecision.navigate;
              },
            ),
            Align(
            alignment: Alignment.bottomLeft,
            child: Container(
            padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
            children: <Widget>[

            SizedBox(width: 15,),
            Expanded(
            child: TextFormField(
            controller: msgboxcontroller,
            onSaved: (value) => chat_msg = value,
            decoration: InputDecoration(
            hintText: "Write message...",
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none
            ),
            ),
            ),
            SizedBox(width: 15,),
            FloatingActionButton(
            onPressed: (){



              print('https://astroashram.com/app_login?redirect_to=user&agentid='+send_agent_id+'&userid='+session_user_id);

              sendmsgtoagent(context);






            },
            child: Icon(Icons.send,color: Colors.white,size: 18,),
            backgroundColor: const Color(0xffe22525),
            elevation: 0,
            ),
            ],

            ),
            ),
            )
            ])
         /* }),*/

          ),


    );

   /* return WebView(
      initialUrl: 'https://astroashram.com/app_login?redirect_to=user&agentid='+send_agent_id+'&userid='+session_user_id,
    );*/

  }

}
