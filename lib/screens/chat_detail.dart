import 'dart:async';
import 'dart:convert';
import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/NotifySendRequest.dart';
import 'package:ascology_app/model/request/chat_send_request.dart';
import 'package:ascology_app/model/request/check_endchat_request.dart';
import 'package:ascology_app/model/request/get_chat_request.dart';
import 'package:ascology_app/model/request/update_chatstatus_request.dart';
import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/get_chat_listing.dart';
import 'package:ascology_app/model/response/get_chat_listing_response.dart';
import 'package:ascology_app/model/response/get_status_response.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/astrologer_desc_page.dart';
import 'package:ascology_app/screens/user_chat.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;



class ChatDetailPage extends StatefulWidget {

  String chat_agent_id,chat_user_id,chat_agent_name,chat_agent_img,chat_agent_price,chat_fcm_token;

  // UserVerifyOtp({this.mobile,this.usertype});

 // ChatDetailPage({this.chat_agent_id,this.chat_agent_name,this.chat_agent_img,this.chat_agent_price});
  ChatDetailPage({this.chat_agent_id,this.chat_agent_name,this.chat_agent_img,this.chat_fcm_token});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  Timer timer,timer2;
 // List chatmsglist = [];
  List<ChatDetails> chatmsglist = List();
  List searchlist = [];
  bool isLoading = false;

  String send_agent_id,send_agent_name,chat_msg,session_user_id,send_agent_img,send_agent_price,send_fcm_token;
  // final AstrologerDetails astrologerDetails;

  SharedPreferences logindata;

  Widget appBarTitle = Text(
    "Chat",
    style: TextStyle(color: Colors.white),
  );
  Icon actionIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  final key = GlobalKey<ScaffoldState>();
  TextEditingController msgboxcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getConnectivity();
   /* send_agent_id = widget.chat_agent_id;
    send_agent_name = widget.chat_agent_name;
    send_agent_img = widget.chat_agent_img;*/

     send_agent_id = widget.chat_agent_id;
    send_agent_name = widget.chat_agent_name;
    send_agent_img = widget.chat_agent_img;
    send_fcm_token = widget.chat_fcm_token;

    //  send_agent_price = widget.chat_agent_price;
    print(send_agent_id);
    //this.getchatmessages(context);

    this.getchatlist(context);
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) =>  getchatlist(context));
    timer2 = Timer.periodic(Duration(seconds: 3), (Timer t) =>  check_if_chat_ended());

    /*Future.delayed(Duration(seconds: 3), (){
      print("Executed after 5 seconds");

      getchatlist(context);
    });*/


   /* Future.delayed(Duration(seconds: 5), (){
      print("Executed after 5 seconds");
        check_if_chat_ended();
    });*/

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
    timer.cancel();
    timer2.cancel();
    chatmsglist.clear();
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


  void getchatlist(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_user_id = logindata.getString('user_id');
    });

    setState(() {
      //isLoading = true;
    });

    GetChatListRequestModel requestBody = GetChatListRequestModel();
    requestBody.user_id = session_user_id;
    requestBody.agent_id = send_agent_id;
    requestBody.chat_from = "user";
    requestBody.chat_to = "agent";

    LoginApiClient api = LoginApiClient();

    chatmsglist = await api.getuserdetailchat(requestBody);

    setState(() {
      chatmsglist = chatmsglist;
    });



  }



  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return new WillPopScope(
        onWillPop: () async => false,
    child: new Scaffold(

      appBar: AppBar(
        elevation: 0,
        //automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffe22525),
        flexibleSpace: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/getnow.png'),
                    fit: BoxFit.fill
                )
            ),
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.white,),
                ),
                SizedBox(width: 2,),
                CircleAvatar(
                  backgroundImage: NetworkImage('https://astroashram.com/uploads/agent/'+send_agent_img),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(send_agent_name.toString(),style: TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5 ,fontWeight: FontWeight.w600,color: Colors.white),),
                      SizedBox(height: 6,),
                      //Text("Online",style: TextStyle(color: Colors.white, fontSize: 13),),
                    ],
                  ),
                ),

                ElevatedButton(
                  child: Text('End Chat',style: TextStyle( fontSize: cf.Size.blockSizeHorizontal *2.8)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green),
                  onPressed: () {

                   // sendendchat();

                    send_user_end_chat();

                  },

                ),
             //   Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ),
      /*appBar: AppBar(
        title: Text("Chat"),backgroundColor: const Color(0xffe069c3),
      ),*/
      //appBar : buildBar(context),
      body:

      Stack(
        children: <Widget>[
         ListView.builder(
            itemCount: chatmsglist.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 0,bottom: 70),
          //  physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (chatmsglist[index].chat_from == "agent"?Alignment.topLeft:Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chatmsglist[index].chat_from == "agent"?Colors.grey.shade200:Colors.blue[200]),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                       // Text( (new DateFormat('yyyy-MM-dd HH:mm:ss').parse(chatmsglist[index].entry_date)).toString(), style: TextStyle(fontSize: 15),),

                        Text(chatmsglist[index].txt_message, style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3),),
                        SizedBox(height: 2,),
                        Text(chatmsglist[index].entry_date, style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.5,color: Colors.blueGrey),),

                      ],
                    ),
                  ),
                ),
              );
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
                 /* GestureDetector(
                    onTap: (){

                    },


                    child:
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xffe22525)Accent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),*/
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextFormField(
                      controller: msgboxcontroller,
                      onSaved: (value) => chat_msg = value,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54,fontSize: cf.Size.blockSizeHorizontal * 3),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){

                      sendmsgtoagent(context);

                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: const Color(0xffe22525),
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),

      //  getBody(),
    )
    );
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
                getchatlist(context);

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

  void check_if_chat_ended() async{

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_user_id = logindata.getString('user_id');
    });

    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");

      var _loginApiClient = LoginApiClient();
    CheckendChatRequestModel chatSendRequestModel = new CheckendChatRequestModel();

      chatSendRequestModel.agent_id = send_agent_id;
      print(send_agent_id);
      print(session_user_id);
      chatSendRequestModel.user_id = session_user_id;
      chatSendRequestModel.type = "Agent";

    StatusResponse registerResModel = await _loginApiClient.checkendchat(chatSendRequestModel);

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

        if(registerResModel.message == "Chat end")
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserDashboard()),);

          }


        // openSubscriptionPage(context, registerResModel);

        /*  Flushbar(
                     // title: 'Invalid form',
                      message: registerResModel.message,
                      duration: Duration(seconds: 5),
                    ).show(context);
*/


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

  void send_user_end_chat () async{

   logindata = await SharedPreferences.getInstance();
    setState(() {
      session_user_id = logindata.getString('user_id');
    });


    var _loginApiClient = LoginApiClient();
    UpdateChatStatusRequestModel chatSendRequestModel = new UpdateChatStatusRequestModel();

    chatSendRequestModel.user_id = session_user_id;
    chatSendRequestModel.ChatStatus = '1';
    chatSendRequestModel.agent_id = send_agent_id;

    UserChangePasswordResponseModel registerResModel = await _loginApiClient.updateuserchatstatus(chatSendRequestModel);

    if(registerResModel.status == true){
    //  timer.cancel();
      Fluttertoast.showToast(
          msg: "Chat ended...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  UserDashboard()));


    }
    else{

      Fluttertoast.showToast(
          msg: "Unable to end chat...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );


    }



  }



}