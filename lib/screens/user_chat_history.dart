
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_login_request.dart';
import 'package:ascology_app/model/request/user_callhistory_request.dart';
import 'package:ascology_app/model/request/user_mobile_request.dart';
import 'package:ascology_app/model/response/agent_login_response.dart';
import 'package:ascology_app/model/response/user_chat_hist_response.dart';
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
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class UserChatHistory extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _UserChatHistoryState createState() => _UserChatHistoryState();
}

class _UserChatHistoryState extends State<UserChatHistory> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  final formKey = GlobalKey<FormState>();
  String session_user_id,session_user_mobile,hist_fromdate,hist_todate,search_text,pass_fromdate,pass_todate;
  SharedPreferences logindata;
  bool isLoading = false;

  List<UserChatHistResponse> chathistorylist = List();
  List<UserChatHistResponse> searchlist = List();

  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();
  String passformatter = DateFormat("yyyy-MM-dd").format(DateTime.now());// 28/03/2020

  DateTime selectedDate = DateTime.now();

  final now = new DateTime.now();
  String formatter = DateFormat("dd-MM-yyyy").format(DateTime.now());// 28/03/2020

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    getuserchathistory();

    /*   fromdatecontroller.text = formatter;
    todatecontroller.text = formatter;
    this.getuser_callhistory_current();*/
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
      results = chathistorylist;
    } else {
      results = chathistorylist
          .where((user) =>
          user.agentname.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      searchlist = results;
    });
  }


  @override
  Widget build(BuildContext context) {

    cf.Size.init(context);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chat History', style: TextStyle(
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
            child:

            Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                 /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Expanded( child:
                      TextFormField(
                        style: TextStyle(
                            fontSize: cf.Size.blockSizeHorizontal * 3,
                            fontFamily: "Poppins"),
                        autofocus: false,
                        onSaved: (value) => hist_fromdate = value,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          //add prefix icon
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.red,
                          ),


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "From Date",

                          //make hint text
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: cf.Size.blockSizeHorizontal * 3,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'From Date',
                          //lable style
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: cf.Size.blockSizeHorizontal * 3.5,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        controller: fromdatecontroller,
                        onTap: ()
                        {
                          _selectDatefrom(context);
                        },


                      ),
                      ),
                    ],
                  ),


                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Expanded(child:
                      TextFormField(
                        style: TextStyle(
                            fontSize: cf.Size.blockSizeHorizontal * 3,
                            fontFamily: "Poppins"),
                        autofocus: false,
                        onSaved: (value) => hist_todate = value,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          //add prefix icon
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.red,
                          ),


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "To Date",

                          //make hint text
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: cf.Size.blockSizeHorizontal * 3,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'To Date',
                          //lable style
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: cf.Size.blockSizeHorizontal * 3.5,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        controller: todatecontroller,
                        onTap: ()
                        {
                          _selectDateto(context);
                        },
                      ),

                      ),

                    ],
                  ),

                  TextField(
                    // onChanged: (value) => search(value),
                    onChanged: (value) => _runFilter(value),
                    //_runFilter(value),
                    decoration: const InputDecoration(
                        labelText: 'Search', suffixIcon: Icon(Icons.search)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xffe22525)),
                      child: Text("Show",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3.5,),),
                      onPressed: ()
                      {
                        searchlist.clear();
                        callhistorylist.clear();


                        getuser_callhistory();

                      },
                    ),
                  ),
*/



                  Expanded(
                    child: //
                    searchlist.isNotEmpty

                        ?
                    RefreshIndicator(
                        onRefresh: () async {
                          await Future.delayed(Duration(seconds: 2));
                          this.getuserchathistory();
                        },
                        child:
                        ListView.builder(
                          itemCount: searchlist.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          // padding: EdgeInsets.only(top: 10,bottom: 10),
                          //  physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return Container(
                              padding: EdgeInsets.only(left: 5,right: 0,top: 5,bottom: 5),
                              child:
                              Column(
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
                                                    child: Text('Agent name : '+searchlist[index].agentname, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525)))),
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
                                                    child: Text('Date : ' +searchlist[index].DateTime, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525)
                                                        ))),
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
                                                    child: Text('Duration : ' +searchlist[index].duration+' min', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525)))),
                                                ),

                                              ],
                                            ),



                                        /*    Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Expanded(child:
                                                Container
                                                  (width: MediaQuery.of(context).size.width,
                                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                    height: 20,
                                                    child: Text('Customer Bill Rate:  Rs. ' +searchlist[index].cust_bill_rate +'/min', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                                    height: 20,
                                                    child: Text('Call Status : ' +searchlist[index].disposition, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                                ),

                                              ],
                                            ),
*/
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Expanded(child:
                                                Container
                                                  (width: MediaQuery.of(context).size.width,
                                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                    height: 20,
                                                    child: Text('Agent Extension : ' +searchlist[index].AgentExtension, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525)))),
                                                ),

                                              ],
                                            ),

                                         /*   Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Expanded(child:
                                                Container
                                                  (width: MediaQuery.of(context).size.width,
                                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                    height: 20,
                                                    child: Text('Agent Name : ' +searchlist[index].agentname, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                                    child: Text('Customer Bal before call :  ₹ ' +searchlist[index].cust_bbc, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525)))),
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
                                                    height: 20,
                                                    child: Text('Customer Bal after call :  ₹ ' +searchlist[index].cust_bac, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                                ),

                                              ],
                                            ),
*/
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Expanded(child:
                                                Container
                                                  (width: MediaQuery.of(context).size.width,
                                                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                                    height: 20,

                                                    child: Text('Cust Bill Amount :  ₹  ${searchlist[index].cust_bill_amt}', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525)
                                                    ))),
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

                    )

                        :  Center(
                          child: Text(
                      'No results found',
                      style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 4),
                    ),
                        ),
                  ),


                ]
            ),
          ),
        )
    );
  }


  _selectDatefrom(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;

        //  selectedDate = DateFormat("yyyy-MM-dd").format(selectedDate);

        // hist_fromdate = ' ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
        // hist_fromdate = ' ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
        hist_fromdate = DateFormat("dd-MM-yyyy").format(selectedDate);

        // hist_fromdate = ' ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
        pass_fromdate = DateFormat("yyyy-MM-dd").format(selectedDate);

        fromdatecontroller.text = hist_fromdate;
      });
  }

  _selectDateto(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );

    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;

        // hist_todate = ' ${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
        //hist_todate = ' ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
        hist_todate = DateFormat("dd-MM-yyyy").format(selectedDate);
        //  hist_todate = ' ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';

        pass_todate = DateFormat("yyyy-MM-dd").format(selectedDate);
        todatecontroller.text = hist_todate;
      });
  }



  getuserchathistory() async {

    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    session_user_mobile = logindata.getString('user_mobile');

    LoginApiClient api = LoginApiClient();
    UserChatHistRequest requestModel = new UserChatHistRequest();

    requestModel.mobile = session_user_mobile;

    chathistorylist = await api.getuserchathistory(requestModel);
    setState(() {
      chathistorylist = chathistorylist;
      searchlist = chathistorylist;
      isLoading = false;
    });

  }

}