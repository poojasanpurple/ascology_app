import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/NewAgentRequestModel.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/followers_response.dart';
import 'package:ascology_app/model/response/get_chat_listing.dart';
import 'package:ascology_app/model/response/review_detail.dart';
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



class AgentReview extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentReviewState createState() => _AgentReviewState();
}

class _AgentReviewState extends State<AgentReview> {

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController fromdatecontroller = TextEditingController();

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  String session_agent_id,hist_fromdate;
  SharedPreferences logindata;
  List<ReviewDetails> dataFromServer = List();
  List<ReviewDetails> searchlist = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    this.getagentreview(context);
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



  void getagentreview(BuildContext context) async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_agent_id = logindata.getString('agent_id');
    });

    setState(() {
      isLoading = true;
    });

    LoginApiClient api = LoginApiClient();
    NewAgentRequestModel requestModel = new NewAgentRequestModel();

    requestModel.agent_id = session_agent_id;
    requestModel.search = '';

    dataFromServer = await api.getagentreviews(requestModel);

    setState(() {
      dataFromServer = dataFromServer;
      searchlist = dataFromServer;
      isLoading = false;

    });

  }


  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reviews', style: TextStyle(
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



    Flexible(
          child: searchlist.isNotEmpty ?

          ListView.builder(
            itemCount: searchlist.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            // padding: EdgeInsets.only(top: 10,bottom: 10),
            //  physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 10,right: 0,top: 5,bottom: 5),
                child:
                Row(
                  children: [
                    Flexible(child:
                    Card(
                      elevation: 1.5,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Column(
                            children: <Widget>[

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Expanded(child:
                                  Container
                                    (width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      height: 20,
                                      child: Text('User Name : '+searchlist[index].name, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                  ),

                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Expanded(child:
                                  Container
                                    (width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      height: 20,
                                      child: Text('Rating : ' +searchlist[index].rating, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                  ),

                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Expanded(child:
                                  Container
                                    (width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      height: 20,
                                      child: Text('Comment : ' +searchlist[index].comment, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                  ),

                                ],
                              ),


                            ],

                          ),
                        ),
                      ),
                    ),
                    ),
                  ],
                ),
              );
            },
          )

      :  Text(
      'No results found',
      style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,),textAlign: TextAlign.center,
    ),

        ),
    ],
      ),
    ),
    )
    );

  }

}
