
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_login_request.dart';
import 'package:ascology_app/model/request/user_callhistory_request.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/agent_login_response.dart';
import 'package:ascology_app/model/response/user_transaction_response.dart';
import 'package:ascology_app/model/response/usercall_history_reponse.dart';
import 'package:ascology_app/screens/agent_forgtpasswd.dart';
import 'package:ascology_app/screens/agent_home.dart';
import 'package:ascology_app/screens/agent_register.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class UserTransactionHistory extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _UserTransactionHistoryState createState() => _UserTransactionHistoryState();
}

class _UserTransactionHistoryState extends State<UserTransactionHistory> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final formKey = GlobalKey<FormState>();
  String session_user_id,session_user_mobile,hist_fromdate,hist_todate;
  SharedPreferences logindata;
  bool isLoading = false;

  List<TransactionHistoryResponse> trans_hist_list = List();

  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();

  DateTime selectedDate = DateTime.now();

  String apkversion = '1.0';
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
    this.getuser_transaction_history();
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
            title: Text('Transaction History', style: TextStyle(
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


          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                Expanded(child:
                ListView.builder(
                  itemCount: trans_hist_list.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  // padding: EdgeInsets.only(top: 10,bottom: 10),
                  //  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.only(left: 10,right: 0,top: 5,bottom: 5),
                      child:
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
                                        child: Text('Name: '+trans_hist_list[index].name, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                    ),

                                  ],
                                ),
                                /* Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(child:
                            Container
                              (width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                height: 15,
                                child: Text('Customer Name : ' +callhistorylist[index].name, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                            ),

                          ],
                        ),*/
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    Expanded(child:
                                    Container
                                      (width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        height: 20,
                                        child: Text('Amount :  Rs. ' +trans_hist_list[index].pay_amount, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                        child: Text('Payment Id : ' +trans_hist_list[index].payment_id, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                    ),

                                  ],
                                ),
                                /* Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Expanded(child:
                            Container
                              (width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                height: 15,
                                child: Text('Problem Area : ' +callhistorylist[index].short_description, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold),maxLines: 3,)),
                            ),

                          ],
                        ),*/
                                /* Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Expanded(child:
                            Container
                              (width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                height: 15,
                                child: Text('Order time : ' +callhistorylist[index].calldate, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                            ),

                          ],
                        ),*/

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    Expanded(child:
                                    Container
                                      (width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        height: 20,
                                        child: Text('Payment Date : ' +trans_hist_list[index].payment_date, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                        child: Text('Payment Mode : ' +trans_hist_list[index].payment_mode, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                        child: Text('Status : ' +trans_hist_list[index].payment_status, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                    ),

                                  ],
                                ),



                              ],

                            ),
                          ),
                        ),
                      ),
                      ),
                    );
                  },
                ),
                ),
              ]
          ),
        )
    );
  }


  void getuser_transaction_history() async {

    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

    LoginApiClient api = LoginApiClient();
    UserRequestModel requestModel = new UserRequestModel();

    requestModel.user_id = session_user_id;

    trans_hist_list = await api.gettransactionhistory(requestModel);
    setState(() {

      trans_hist_list = trans_hist_list;
      // searchlist = callhistorylist;
      isLoading = false;
    });

  }
}