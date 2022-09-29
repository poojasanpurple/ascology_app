
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_callhistory_request.dart';
import 'package:ascology_app/model/request/agent_login_request.dart';
import 'package:ascology_app/model/request/user_callhistory_request.dart';
import 'package:ascology_app/model/response/agent_login_response.dart';
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

class AgentCallHistory extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AgentCallHistoryState createState() => _AgentCallHistoryState();
}

class _AgentCallHistoryState extends State<AgentCallHistory> {

  final formKey = GlobalKey<FormState>();
  String session_agent_id,session_extension,hist_fromdate,hist_todate,search_text,pass_fromdate,pass_todate;
  SharedPreferences logindata;
  bool isLoading = false;

  List<CallHistoryResponse> callhistorylist = List();
  List<CallHistoryResponse> searchlist = List();

  DateTime selectedDate = DateTime.now();

  final now = new DateTime.now();
 // String formatter = DateFormat("yyyy-MM-dd").format(DateTime.now());// 28/03/2020
  String formatter = DateFormat("dd-MM-yyyy").format(DateTime.now());// 28/03/2020
  String passformatter = DateFormat("yyyy-MM-dd").format(DateTime.now());// 28/03/2020

  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();


  String apkversion = '1.0';
  String deviceName = '';
  String device_model = '';
  String deviceVersion = '';
  String identifier = '';
  String token = '';
  String imei_number='';
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    getagent_callhistory_current();
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
      results = callhistorylist;
    } else {
      results = callhistorylist
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


  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);

    return SafeArea(
        child: Scaffold(
          appBar:AppBar(
            title: Text('Call History', style: TextStyle(
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
      margin: EdgeInsets.all(20.0),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

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
      /*decoration: buildInputDecoration(
      "Enter From Date", Icons.calendar_today),*/
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
   /*  Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [*/

/*new Card(
              child: new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: searchcontroller,
                  decoration: new InputDecoration(
                      hintText: 'Search', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: BorderSide(color: const Color(0xffe22525)
                  ))),
                  onChanged: onSearchTextChanged,
                ),
                trailing: new IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                  searchcontroller.clear();
                  onSearchTextChanged('');
                },),
              ),
            ),*/

           /* Expanded(child:
            TextFormField(
              autofocus: false,
              onSaved: (value) => hist_todate = value,
              decoration: buildInputDecoration(
                  "Search", Icons.search),
              controller: searchcontroller,
              onChanged : onSearchTextChanged,

            ),

            ),*/

          /*],
        ),*/

        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          alignment: Alignment.center,
          child : ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: const Color(0xffe22525)),
            child: Text("Show",style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,fontWeight: FontWeight.w400),),
            onPressed: ()
            {

              searchlist.clear();
              callhistorylist.clear();

              getagent_callhistory();
              // Navigator.pushReplacementNamed(context, '/login');
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);


            },
          ),
        ),

       /* Expanded(
          child: searchlist.isNotEmpty ?
          Container(
            width: cf.Size.screenWidth,
            height: cf.Size.screenHeight,
            alignment: AlignmentDirectional.center,
            child: Container(
               // margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Center(
                  child: Text('No data available',style: TextStyle(fontFamily: 'Poppins',fontSize: 20,color: const Color(0xffe22525),fontWeight: FontWeight.bold)),
                )
            ),
          )
              :*/

      Expanded(
          child: //
          searchlist.isNotEmpty

              ?
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              this.getagent_callhistory();
            },
            child:
          ListView.builder(
            itemCount: searchlist.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            // padding: EdgeInsets.only(top: 10,bottom: 10),
            //  physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.only(left: 10,right: 0,top: 5,bottom: 5),
                child:
              //  Flexible(child:
                Card(
                  elevation: 1.5,
                  child:
             /* Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: */
                  ListTile(
                      title: Column(
                        children: <Widget>[

                         /* Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(child:
                              Container
                                (width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 20,
                                  child: Text('Order Id : '+searchlist[index].id, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                 // Text(cart_prod_qty!=null?cart_prod_qty:'default value'),
                                  //child: Text('Customer Name : ' +searchlist[index].name!=null?searchlist[index].name:'-', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                                  child: Text('Customer Name :  ${searchlist[index].CustName}', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  child: Text('Call Date : ' +searchlist[index].calldate, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  child: Text('Agent Payment Rate : ' +searchlist[index].agent_pay_rate+' /Min', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 3,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  child: Text('Duration : ' +searchlist[index].duration+' Min', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8, color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                        child: Text('Customer Bill Rate:  Rs. ' +searchlist[index].cust_bill_rate +'/minute', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  child: Text('Extension : ' +searchlist[index].extension, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                              ),

                            ],
                          ),
*/

/*

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(child:
                              Container
                                (width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 15,
                                  child: Text('Customer Balance before call : ' +searchlist[index].cust_bbc, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                              ),

                            ],
                          ),
*/

                        /*  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(child:
                              Container
                                (width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 15,
                                  child: Text('Customer Balance after call : ' +searchlist[index].cust_bac, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                              ),

                            ],
                          ),
*/
                         /* Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(child:
                              Container
                                (width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 20,
                                  child: Text('Agent Bill :  ₹ ' +searchlist[index].cust_bill_amt, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  child: Text('Call Status : ' +searchlist[index].disposition, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins', fontSize: cf.Size.blockSizeHorizontal * 2.8,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                              ),

                            ],
                          ),

                        ],

                      ),
                    ),
                //  ),
                ),
               // ),
              );

            },
          )

       /*   new
          ListView.builder(
            itemCount: callhistorylist.length,
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
                                  height: 15,
                                  child: Text('Order Id : '+callhistorylist[index].id, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
                              ),

                            ],
                          ),
                          *//* Row(
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
                          ),*//*
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(child:
                              Container
                                (width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 15,
                                  child: Text('Call Date : ' +callhistorylist[index].calldate, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  height: 15,
                                  child: Text('Duration : ' +callhistorylist[index].min+' minutes', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color:const Color(0xffe22525),fontWeight: FontWeight.bold))),
                              ),

                            ],
                          ),
                          *//* Row(
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
                          ),*//*
                          *//* Row(
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
                          ),*//*

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              Expanded(child:
                              Container
                                (width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 15,
                                  child: Text('Customer Bill Rate:  Rs. ' +callhistorylist[index].cust_bill_rate +'/minute', textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  height: 15,
                                  child: Text('Call Status : ' +callhistorylist[index].disposition, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  height: 15,
                                  child: Text('Extension : ' +callhistorylist[index].extension, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  height: 15,
                                  child: Text('Name : ' +callhistorylist[index].name, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  height: 15,
                                  child: Text('Customer Balance before call : ' +callhistorylist[index].cust_bbc, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525)
                                      ,fontWeight: FontWeight.bold))),
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
                                  height: 15,
                                  child: Text('Customer Balance after call : ' +callhistorylist[index].cust_bac, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
                                  height: 15,
                                  child: Text('Customer Bill Amount : ' +callhistorylist[index].cust_bill_amt, textAlign:TextAlign.left,style: TextStyle(fontFamily: 'Poppins',fontSize: 12,color: const Color(0xffe22525),fontWeight: FontWeight.bold))),
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
          )*/
          )
        : const Text(
        'No results found',
        style: TextStyle(fontSize: 24),
      ),

          ),



      ]
      ),
    )),
        )
    );
  }

  onSearchTextChanged(String text) async {
    searchlist.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    callhistorylist.forEach((userDetail) {
      if (userDetail.name.contains(text))
        searchlist.add(userDetail);
    });

    setState(() {});
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
        hist_todate = DateFormat("dd-MM-yyyy").format(selectedDate);
      //  hist_todate = ' ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';

        pass_todate = DateFormat("yyyy-MM-dd").format(selectedDate);
        todatecontroller.text = hist_todate;
      });
  }



  getagent_callhistory_current() async {

    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    session_agent_id = logindata.getString('agent_id');
    session_extension = logindata.getString('agent_ext');
    fromdatecontroller.text = formatter;
    todatecontroller.text = formatter;

    LoginApiClient api = LoginApiClient();
    AgentCallHistoryRequestModel requestModel = new AgentCallHistoryRequestModel();

    requestModel.search = '';
    requestModel.extension = session_extension;
    requestModel.fromdate = passformatter;
    requestModel.todate = passformatter;

    print('session_extension'+session_extension);

    callhistorylist = await api.getagentcallhistory(requestModel);
    setState(() {
      callhistorylist = callhistorylist;
       searchlist = callhistorylist;
      isLoading = false;
    });

  }
   getagent_callhistory() async {

    setState(() {
      isLoading = true;
    });

    logindata = await SharedPreferences.getInstance();
    session_agent_id = logindata.getString('agent_id');
    session_extension = logindata.getString('agent_ext');

    String text_fromdate = fromdatecontroller.text;
    String text_todate = todatecontroller.text;

    DateTime dt_from = new DateFormat("dd-MM-yyyy").parse(text_fromdate);
    DateTime dt_to = new DateFormat("dd-MM-yyyy").parse(text_todate);

    String final_fromdate = DateFormat("yyyy-MM-dd").format(dt_from);
    String final_todate = DateFormat("yyyy-MM-dd").format(dt_to);

    LoginApiClient api = LoginApiClient();
    AgentCallHistoryRequestModel requestModel = new AgentCallHistoryRequestModel();

    requestModel.search = '';
    requestModel.extension = session_extension;
   /* requestModel.fromdate = pass_fromdate;
    requestModel.todate = pass_todate;*/
    requestModel.fromdate = final_fromdate;
    requestModel.todate = final_todate;

    print(final_fromdate);
    print(final_todate);

    callhistorylist = await api.getagentcallhistory(requestModel);
    setState(() {
      callhistorylist = callhistorylist;
       searchlist = callhistorylist;
      isLoading = false;
    });

  }
}