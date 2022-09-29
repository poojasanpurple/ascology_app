import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/NewAgentRequestModel.dart';
import 'package:ascology_app/model/request/agent_reject_request.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/agent_user_request.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/agent_chat_detail.dart';
import 'package:ascology_app/model/response/agent_chat_msg.dart';
import 'package:ascology_app/model/response/get_chat_listing.dart';
import 'package:ascology_app/model/response/user_chat_list_response.dart';
import 'package:ascology_app/model/response/user_chatlist_detail.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/screens/agent_chat_detail_page.dart';
import 'package:ascology_app/screens/agent_chat_webview.dart';
import 'package:ascology_app/screens/agent_home.dart';
import 'package:ascology_app/screens/chat_detail.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ascology_app/global/configFile.dart' as cf;


class AgentChat extends StatefulWidget {
  // const Login({Key key}) : super(key: key);
  String username;
  AgentChat({ this.username});

  @override
  _AgentChatState createState() => _AgentChatState();
}

class _AgentChatState extends State<AgentChat> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Timer timer;
  String session_agent_id,selected_user_id,selected_user_name,selected_user_img,selected_agent_id,chat_user_id,chat_user_name;
  SharedPreferences logindata;
  List<AgentChatDetail> dataFromServer = List();
  List<AgentChatMsg> chatlist = List();
  List agentchatlist = [];
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    this.getagent_user_chats(context);
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) =>  getagent_user_chats(context));

    //this.getagent_user_chats(context);
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
    chatlist.clear();
   subscription.cancel();
    super.dispose();
  }

  void getagent_user_chats(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
      print(session_agent_id);
    });

    setState(() {
    //  isLoading = true;
    });

    LoginApiClient api = LoginApiClient();
    NewAgentRequestModel requestModel = new NewAgentRequestModel();

    requestModel.agent_id = session_agent_id;
    requestModel.search = '';
    print('session_agent_id'+session_agent_id);
    chatlist = await api.newagentchatdata(requestModel);


    setState(() {
      chatlist = chatlist;
    });


  }


  void getagentchats(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
      print(session_agent_id);
    });

    setState(() {
     // isLoading = true;
    });

    LoginApiClient api = LoginApiClient();
    AgentRequestModel requestModel = new AgentRequestModel();

    requestModel.agent_id = session_agent_id;

    print(session_agent_id);
    dataFromServer = await api.agentchatdata(requestModel);
    print(dataFromServer.toString());

    setState(() {
      dataFromServer = dataFromServer;
     // isLoading = false;
    });

  }

  void acceptchatdata(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
      print(session_agent_id);
    });
/*
    setState(() {
      isLoading = true;
    });*/

    var _loginApiClient = LoginApiClient();
    AgentRejectRequest requestModel = new AgentRejectRequest();

    // requestModel.agent_id = session_agent_id;
    requestModel.agent_id = selected_agent_id;
    requestModel.user_id = selected_user_id;

    UserForgetPasswordResponseModel userModel = await _loginApiClient
        .agent_user_chat(requestModel);
    print("!Q!Q!QQ!Q!Q!Q $userModel");
    if (userModel.status == true) {
      print('Password sent to mobile number');

      Fluttertoast.showToast(
        msg: userModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: cf.Size.blockSizeHorizontal * 3.5,
      );

      // Navigator.pop(context);

    }
    else {
      //  loaderFun(context, false);
      print('Invalid mobile number');
      Fluttertoast.showToast(
        msg: userModel.message,
        toastLength: Toast.LENGTH_SHORT,
        gravity:  ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: cf.Size.blockSizeHorizontal * 3.5,
      );

    }

  }


  void rejectchatdata(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
      print(session_agent_id);
    });
/*
    setState(() {
      isLoading = true;
    });*/

    var _loginApiClient = LoginApiClient();
    AgentRejectRequest requestModel = new AgentRejectRequest();

   // requestModel.agent_id = session_agent_id;
    requestModel.agent_id = selected_agent_id;
    requestModel.user_id = selected_user_id;



    UserForgetPasswordResponseModel userModel = await _loginApiClient
        .agent_reject_user_chat(requestModel);
    print("!Q!Q!QQ!Q!Q!Q $userModel");
    if (userModel.status == true) {
      print('Password sent to mobile number');

     /* Fluttertoast.showToast(
          msg: selected_user_id.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );*/

      Fluttertoast.showToast(
          msg: userModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: cf.Size.blockSizeHorizontal * 3.5,
      );

     // Navigator.pop(context);

      chatlist.clear();

      getagent_user_chats(context);

    }
    else {
      //  loaderFun(context, false);
      print('Invalid mobile number');
      Fluttertoast.showToast(
          msg: userModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity:  ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: cf.Size.blockSizeHorizontal * 3.5,
      );



    }

  }

  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat', style: TextStyle(
              color: Colors.white,
              fontSize: cf.Size.blockSizeHorizontal * 4,
          ),) ,

          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AgentHomePage()),
              );
            },
          ),
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
        WillPopScope(
          onWillPop: () async {
            /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The System Back Button is Deactivated')));*/
            return false;
          },
          child:
        Container(
          child: chatlist.isEmpty ?

         // Center(child: new CircularProgressIndicator())
          Center(
            child: Container(
              width: cf.Size.screenWidth,
              height: cf.Size.screenHeight,
              alignment: AlignmentDirectional.center,
              child: Container(
                  child: Center(
                      child:
                       Text(
                        'No chats found',
                        style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 4,),textAlign: TextAlign.center,
                      ),
/*Image.asset(
                        "assets/images/loader.gif",
                        height: cf.Size.screenHeight / 3,
                        width: cf.Size.screenWidth / 1.8,
                      )*/
                  )
              ),
            ),
          )
              :

          /*  ListView.builder(
            itemCount: dataFromServer.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return UserChat(
                agentname : dataFromServer[index].agentname,
              //  imageUrl: dataFromServer[index].imageURL,
              //  time: chatUsers[index].time,
                //isMessageRead: (index == 0 || index == 3)?true:false,
              );
            },
          ),*/

          ListView.separated(
            itemCount: chatlist.length,
            itemBuilder: (context, index) {
              if(chatlist!=null && chatlist.length!=0)
              {
                return
                  ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10,2,10,2),
                  leading:

                  CircleAvatar(
                    radius: 16.0,
                    child: ClipRRect(
                      child: Image.asset('assets/images/profile.png'),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),/*CircleAvatar(
                    backgroundImage: NetworkImage('https://astroashram.com/uploads/agent/'+dataFromServer[index].image),
                    maxRadius: 20,
                  ),*/
                  title:
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                      Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[

                        Text(
                    chatlist[index].name,
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3.5,
                        fontWeight: FontWeight.w500,color:Colors.black),
                    textAlign: TextAlign.start,
                  ),


                        /*Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[*/

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,3,0,0),
                        child: Text(
                          'New message',
                         // chatlist[index].txt_message,
                          style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 2.5,
                              fontWeight: FontWeight.w300,color: Colors.blueGrey),
                          textAlign: TextAlign.start,
                        ),
                      ),

                      ],),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,0,0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green),
                        child: Text("Accept", style: TextStyle(
                            fontSize: cf.Size.blockSizeHorizontal *2,
                           ),),
                        onPressed: ()
                        {

                          acceptchatdata(context);

                          selected_user_id = chatlist[index].user_id;
                          selected_agent_id = chatlist[index].agent_id;
                          selected_user_name = chatlist[index].name;
                          //selected_user_img = dataFromServer[index].image;

                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AgentChatDetailPage(chat_user_id: selected_user_id,chat_user_name: selected_user_name) ;
                                },
                              ));

                        /*  Fluttertoast.showToast(
                              msg: selected_user_id.toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );*/

                        /*  Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AgentChatWebview(chat_user_id: selected_user_id) ;
                                },
                              ));*/


                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,10,0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xffe22525)),
                        child: Text("Reject",style: TextStyle(
                            fontSize: cf.Size.blockSizeHorizontal *2,
                        )),
                        onPressed: ()
                        {
                          selected_user_id = chatlist[index].user_id;
                          selected_agent_id = chatlist[index].agent_id;

                          rejectchatdata(context);
                        }
                      ),
                    ),


                  ]),


                 /*   ],
                  ),
*/

                  onTap: ()
                  {

                   /* Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatDetailPage(chat_agent_id: selected_user_id,chat_agent_name: selected_user_name,chat_agent_img: selected_user_img) ;
                          },
                        ));*/

                  },

                );
              }
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      ),
       /* body: Container(
          child: dataFromServer.isEmpty ?
          Container(
            width: cf.Size.screenWidth,
            height: cf.Size.screenHeight,
            alignment: AlignmentDirectional.center,
            child: Container(
                child: Center(
                    child: Image.asset(
                      "assets/images/loader.gif",
                      height: cf.Size.screenHeight / 3,
                      width: cf.Size.screenWidth / 1.8,
                    )
                )
            ),
          )
              :

          *//*  ListView.builder(
            itemCount: dataFromServer.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return UserChat(
                agentname : dataFromServer[index].agentname,
              //  imageUrl: dataFromServer[index].imageURL,
              //  time: chatUsers[index].time,
                //isMessageRead: (index == 0 || index == 3)?true:false,
              );
            },
          ),*//*
          ListView.separated(
            itemCount: dataFromServer.length,
            itemBuilder: (context, index) {
              if(dataFromServer!=null && dataFromServer.length!=0)
              {
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10,2,10,2),
                    leading:    CircleAvatar(
                backgroundImage: NetworkImage('https://astroashram.com/uploads/agent/'+dataFromServer[index].image),
              maxRadius: 20,
              ),
                  title: Text(
                    dataFromServer[index].name,
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 4.5,
                        fontWeight: FontWeight.w500,color: const Color(0xffe22525)),
                    textAlign: TextAlign.start,
                  ),

                  onTap: ()
                  {
                    selected_user_id = dataFromServer[index].user_id;
                    selected_user_name = dataFromServer[index].name;
                    selected_user_img = dataFromServer[index].image;

                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatDetailPage(chat_agent_id: selected_user_id,chat_agent_name: selected_user_name,chat_agent_img: selected_user_img) ;
                          },
                        ));

                  },

                );
              }
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
*/


      ),
    );

  }

}
