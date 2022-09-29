import 'dart:async';
import 'dart:convert';
import 'package:ascology_app/model/LoginApiClient.dart';
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
import 'package:ascology_app/screens/agent_dashboard.dart';
import 'package:ascology_app/screens/astrologer_desc_page.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AgentChatDetailPage extends StatefulWidget {

  String chat_agent_id,chat_user_id,chat_user_name;

  // UserVerifyOtp({this.mobile,this.usertype});

  //AgentChatDetailPage({this.chat_agent_id,this.chat_agent_name,this.chat_agent_img});
  AgentChatDetailPage({this.chat_user_id,this.chat_user_name});

  @override
  _AgentChatDetailPageState createState() => _AgentChatDetailPageState();
}

class _AgentChatDetailPageState extends State<AgentChatDetailPage> {

  Timer timer,timer1;
  // List chatmsglist = [];
  List<ChatDetails> chatmsglist = List();
  List searchlist = [];
  bool isLoading = false;
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  String send_user_id,send_user_name,chat_msg,session_user_id,send_agent_img,session_agent_id;
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

    send_user_id = widget.chat_user_id;
    send_user_name = widget.chat_user_name;
   // send_agent_img = widget.chat_agent_img;
    print(send_user_id);
    getConnectivity();
    //this.getchatmessages(context);
//  this.getchatlist(context);
  getchatlist(context);
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) =>  getchatlist(context));
    timer1 = Timer.periodic(Duration(seconds: 3), (Timer t) =>  check_if_chat_ended());

    //

    // this.fetchUser();
    // searchlist = astrologerslist;
    //_IsSearching = false;

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
  void dispose() {
    timer.cancel();
    timer1.cancel();
    chatmsglist.clear();
    subscription.cancel();
    super.dispose();
  }

  void getchatlist(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
    });

   /* setState(() {
      isLoading = true;
    });*/

    GetChatListRequestModel requestBody = GetChatListRequestModel();
    requestBody.user_id = send_user_id;
    requestBody.agent_id = session_agent_id;
    requestBody.chat_from = "agent";
    requestBody.chat_to = "user";

    LoginApiClient api = LoginApiClient();

    chatmsglist = await api.getuserdetailchat(requestBody);

    setState(() {
      chatmsglist = chatmsglist;
    });
  //  check_if_chat_ended();

  }



  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
    child: new Scaffold(

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
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
               /* CircleAvatar(
                  backgroundImage: NetworkImage('https://astroashram.com/uploads/agent/'+send_agent_img),
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),*/
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(send_user_name.toString(),style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600,color: Colors.white),),
                     // SizedBox(height: 6,),
                      //Text("Online",style: TextStyle(color: Colors.white, fontSize: 13),),
                    ],
                  ),
                ),

                ElevatedButton(
                  child: Text('End Chat'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green),
                  onPressed: () {

                    sendendchat();

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
            // padding: EdgeInsets.only(top: 10,bottom: 10),
              physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                child: Align(
                  alignment: (chatmsglist[index].chat_from == "agent"?Alignment.topRight:Alignment.topLeft),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chatmsglist[index].chat_from == "agent"?Colors.blue[200]:Colors.grey.shade200),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(chatmsglist[index].txt_message, style: TextStyle(fontSize: 15),),
                        SizedBox(height: 2,),
                        Text(chatmsglist[index].entry_date, style: TextStyle(fontSize: 10,color: Colors.blueGrey),),

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
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){



                      sendmsgtouser(context);
                      //check_if_chat_ended();

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

  void check_if_chat_ended() async{

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
    });

    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");

    var _loginApiClient = LoginApiClient();
    CheckendChatRequestModel chatSendRequestModel = new CheckendChatRequestModel();

    chatSendRequestModel.agent_id = session_agent_id;
  //  print(send_agent_id);
   // print(session_user_id);
    chatSendRequestModel.user_id = send_user_id;
    chatSendRequestModel.type = "User";

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

      timer.cancel();
      // openSubscriptionPage(context, registerResModel);

      /*  Flushbar(
                     // title: 'Invalid form',
                      message: registerResModel.message,
                      duration: Duration(seconds: 5),
                    ).show(context);
*/
      if(registerResModel.message == "Chat end")
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  AgentDashboard()),);

      }



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

  void sendmsgtouser(BuildContext context) async{

    chat_msg = msgboxcontroller.text;
    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
    });

    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");
    if(chat_msg != null && chat_msg != ""){

      var _loginApiClient = LoginApiClient();
      ChatSendRequestModel chatSendRequestModel = new ChatSendRequestModel();

      chatSendRequestModel.agent_id = session_agent_id;
      chatSendRequestModel.user_id = send_user_id;
      chatSendRequestModel.msgText = chat_msg;
      chatSendRequestModel.chat_from = "agent";
      chatSendRequestModel.chat_to = "user";

      UserChangePasswordResponseModel registerResModel = await _loginApiClient.sendmsgtouser(chatSendRequestModel);

      if(registerResModel.status == true){

        Fluttertoast.showToast(
            msg: "Message sent successfully...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

        msgboxcontroller.text = '';

        getchatlist(context);
       // timer = Timer.periodic(Duration(seconds: 3), (Timer t) =>  getchatlist(context));
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

        Flushbar(
          // title: 'Invalid form',
          message: 'Unable to create account',
          duration: Duration(seconds: 3),
        ).show(context);

        // Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserVerifyOtp()),);

      }




    }
    else{
      Flushbar(
        // title: 'Invalid form',
        message: 'Please enter your message',
        duration: Duration(seconds: 3),
      ).show(context);
      /*loaderFun(context, false);
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Please enter your full name')));*/
    }
  }

  void sendendchat () async{

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
    });

    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");

      var _loginApiClient = LoginApiClient();
    UpdateChatStatusRequestModel chatSendRequestModel = new UpdateChatStatusRequestModel();

      chatSendRequestModel.agent_id = session_agent_id;
      chatSendRequestModel.ChatStatus = '1';
      //chatSendRequestModel.user_id = '';
      chatSendRequestModel.user_id = send_user_id;

      UserChangePasswordResponseModel registerResModel = await _loginApiClient.updatechatstatus(chatSendRequestModel);

      if(registerResModel.status == true){


        timer.cancel();
        Fluttertoast.showToast(
            msg: "Chat ended...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );

         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  AgentDashboard()));


      }
      else{
        //loaderFun(context, false);
        //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Unable to create account.')));

        Fluttertoast.showToast(
            msg: "Unable to end chat...",
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



}