import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/get_chat_listing.dart';
import 'package:ascology_app/model/response/user_chat_list_response.dart';
import 'package:ascology_app/model/response/user_chatlist_detail.dart';
import 'package:ascology_app/screens/chat_detail.dart';
import 'package:ascology_app/screens/user_chat_webview.dart';
import 'package:ascology_app/screens/user_dashboard.dart';
import 'package:ascology_app/screens/user_home.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ascology_app/global/configFile.dart' as cf;


class UserChat extends StatefulWidget {
  // const Login({Key key}) : super(key: key);
  String agentname;
  UserChat({ this.agentname});

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String session_user_id,selected_agent_id,selected_agent_name,selected_agent_img;
  SharedPreferences logindata;
  List<UserChatDetail> dataFromServer = List();
  List userchatlist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    this.getuserchats(context);
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


 void getuserchats(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_user_id = logindata.getString('user_id');
    });

    setState(() {
      isLoading = true;
    });

    LoginApiClient api = LoginApiClient();
    UserRequestModel requestModel = new UserRequestModel();

    requestModel.user_id = session_user_id;

    dataFromServer = await api.postchatdata(requestModel);

    setState(() {
      dataFromServer = dataFromServer;
    });

  }


  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat', style: TextStyle(
              color: Colors.white,
              fontSize: 22
          ),) ,

          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
            /*  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserHomePage()),
              );*/

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserDashboard()),
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
          child: dataFromServer.isEmpty ?

          Center(child: new CircularProgressIndicator())
          /*Container(
            width: cf.Size.screenWidth,
            height: cf.Size.screenHeight,
            alignment: AlignmentDirectional.center,
            child: Container(
                child: Center(
                    child:
                    const Text(
                      'No chats found',
                      style: TextStyle(fontSize: 24,),textAlign: TextAlign.center,
                    ),
*//*Image.asset(
                      "assets/images/loader.gif",
                      height: cf.Size.screenHeight / 3,
                      width: cf.Size.screenWidth / 1.8,
                    )*//*
                )
            ),
          )*/
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
            physics:  AlwaysScrollableScrollPhysics(), // new
            scrollDirection: Axis.vertical,
            itemCount: dataFromServer.length,
            itemBuilder: (context, index) {
              if(dataFromServer!=null && dataFromServer.length!=0)
                {
                  if (dataFromServer[index].image != null) {
                    dataFromServer[index].image = dataFromServer[index].image;
                  }
                  else {
                    dataFromServer[index].image = '${dataFromServer[index].image}';
                  }
                  if (dataFromServer[index].agentname != null) {
                    dataFromServer[index].agentname = dataFromServer[index].agentname;
                  }
                  else {
                    dataFromServer[index].agentname = '${dataFromServer[index].agentname}';
                  }


              return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(10,2,10,2),
                  leading:    /*CircleAvatar(
                    backgroundImage:*/
                    CachedNetworkImage
                      (
                      fit: BoxFit.cover,
                      imageUrl: "https://astroashram.com/uploads/agent/" +dataFromServer[index].image,
                      placeholder: (context,
                          url) => new CircularProgressIndicator(),
                      errorWidget: (context,
                          url, error) =>
                      new Image.asset(
                          'assets/images/profile.png'),
                    ),
                    //NetworkImage('https://astroashram.com/uploads/agent/'+dataFromServer[index].image),
                  /*  maxRadius: 20,
                  ),*/
                  title: Text(
                    dataFromServer[index].agentname,
                    style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 4.5,
                        fontWeight: FontWeight.w500,color: const Color(0xffe22525)
                    ),
                    textAlign: TextAlign.start,
                  ),

                onTap: ()
                {

                  selected_agent_id = dataFromServer[index].agent_id;
                  selected_agent_name = dataFromServer[index].agentname;
                  selected_agent_img = dataFromServer[index].image;
              // /    dataFromServer[index].

                  Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UserChatWebview(chat_agent_id: selected_agent_id) ;
                        },
                      ));

                /* Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ChatDetailPage(chat_agent_id: selected_agent_id,chat_agent_name: selected_agent_name,chat_agent_img: selected_agent_img) ;
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
      ),
    );

  }

}
