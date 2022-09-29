import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/followers_response.dart';
import 'package:ascology_app/model/response/get_chat_listing.dart';
import 'package:ascology_app/model/response/user_chat_list_response.dart';
import 'package:ascology_app/model/response/user_chatlist_detail.dart';
import 'package:ascology_app/screens/chat_detail.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ascology_app/global/configFile.dart' as cf;


class AgentFollowers extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentFollowersState createState() => _AgentFollowersState();
}

class _AgentFollowersState extends State<AgentFollowers> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String session_agent_id,selected_user_id,selected_user_name;
  SharedPreferences logindata;
  List<FollowersDetails> dataFromServer = List();
  List<FollowersDetails> searchlist = List();
  List agent_followerlist = [];

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    this.getagentfollowers(context);
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


  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = dataFromServer;
    } else {
      results = dataFromServer
          .where((user) =>
          user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      searchlist = results;
    });
  }



  void getagentfollowers(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
    });

    setState(() {
      isLoading = true;
    });

    LoginApiClient api = LoginApiClient();
    AgentRequestModel requestModel = new AgentRequestModel();

    requestModel.agent_id = session_agent_id;
    print(session_agent_id);

    dataFromServer = await api.getcountoffollowers(requestModel);

    setState(() {
      dataFromServer = dataFromServer;
      searchlist = dataFromServer;

    });

  }


  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Followers', style: TextStyle(
              color: Colors.white,
              fontSize: cf.Size.blockSizeHorizontal * 4.0
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
        body:
        Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              TextField(
                style: TextStyle(
                  fontSize: cf.Size.blockSizeHorizontal * 3.5,
                  fontFamily: 'Poppins',
                ),
                // onChanged: (value) => search(value),
                onChanged: (value) => _runFilter(value),
                //_runFilter(value),
                decoration: const InputDecoration(
                    labelText: 'Search', suffixIcon: Icon(Icons.search)),
              ),



              Expanded(
                child: searchlist.isNotEmpty ?

                ListView.separated(
                  physics:  AlwaysScrollableScrollPhysics(), // new
                  scrollDirection: Axis.vertical,
                  itemCount: dataFromServer.length,
                  itemBuilder: (context, index) {
                    if(dataFromServer!=null && dataFromServer.length!=0)
                    {

                      return ListTile(
                        contentPadding: EdgeInsets.fromLTRB(10,2,10,2),
                        title: Text(
                          dataFromServer[index].name,
                          style: TextStyle(
                              fontSize: cf.Size.blockSizeHorizontal * 4.0,
                              fontWeight: FontWeight.w500,color: const Color(0xffe22525)
                          ),
                          textAlign: TextAlign.start,
                        ),

                        onTap: ()
                        {

                          selected_user_id = searchlist[index].user_id;
                          selected_user_name = searchlist[index].name;

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
                )

                    :  Text(
                  'No results found',
                  style: TextStyle(fontSize:  cf.Size.blockSizeHorizontal * 3.5,),textAlign: TextAlign.center,
                ),

              ),
            ],
          ),
        ),

      ),
    );

  }

}
