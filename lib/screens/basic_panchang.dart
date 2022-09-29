
import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/screens/birth_details.dart';
import 'package:ascology_app/screens/match_making.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';


class PanchangPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _PanchangPageState createState() => _PanchangPageState();
}

class _PanchangPageState extends State<PanchangPage> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  final formKey = GlobalKey<FormState>();
  String session_user_id,session_user_mobile,hist_fromdate,hist_todate,search_text,pass_fromdate,pass_todate;
  bool isLoading = false;


  TextEditingController fromdatecontroller = TextEditingController();
  TextEditingController todatecontroller = TextEditingController();
  TextEditingController searchcontroller = TextEditingController();
  String passformatter = DateFormat("yyyy-MM-dd").format(DateTime.now());// 28/03/2020

  DateTime selectedDate = DateTime.now();
  String panchang_res_day ,  panchang_res_tithi , panchang_res_yog ,
  panchang_res_nakshatra ,  panchang_res_karan ,  panchang_res_sunrise ,
    panchang_res_sunset ;
  final now = new DateTime.now();
  String formatter = DateFormat("dd-MM-yyyy").format(DateTime.now());// 28/03/2020

  String res_sunsign,res_pred_date, res_pred;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();

    getdailypanchang();

    /*for(int i= 0 ; i<=11; i++) {
      getdailyhoroscope(strArr_zodiac[i]);
    }*/

    /*Fluttertoast.showToast(
        msg: 'Your subscribed plan is not authorized to access this API. Kindly visit your dashboard',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );*/
    /*   fromdatecontroller.text = formatter;
    todatecontroller.text = formatter;
    this.getuser_callhistory_current();*/
  }

  void getdailypanchang() async {

    DateTime now = DateTime.now();
    String curr_day = now.day.toString();
    String curr_month = now.month.toString();
    String curr_year = now.year.toString();
    String curr_hour = now.hour.toString();
    String curr_minute = now.minute.toString();
    String curr_lat = "18.7250";
    String curr_long = "72.250";
    String curr_tzone = "5.5";
    //  var timezone = now.timeZoneName;
  //  var toffset = now.timeZoneOffset;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://json.astrologyapi.com/v1/basic_panchang/');
    final headers = {"authorization": "Basic " + base64.encode(utf8.encode("619558:fad80d4883db59a54e377aa96f515e72")),"Content-type": "application/json"};

    // place_lat = place_lat.replaceAll('{', '');

    // LoginApiClient api = LoginApiClient();
    //  BirthDetailsRequestModel requestModel = new BirthDetailsRequestModel();

    final json = jsonEncode({"year":curr_year,
      "month":curr_month,
      "day":curr_day,
      "hour":curr_hour,
      "min":curr_minute,
      "lat":curr_lat,
      "lon":curr_long,
      "tzone":curr_tzone});

    final response = await post(url, headers: headers, body: json);
    // main_list = await api.getbirthdetails(requestModel);
    setState(() {
      // main_list = main_list;
      // searchlist = callhistorylist;
      isLoading = false;
    });

    var panchang_response = jsonDecode(response.body.toString());
    print(panchang_response);


      panchang_res_day = panchang_response["day"].toString();
      panchang_res_tithi = panchang_response["tithi"].toString();
      panchang_res_yog = panchang_response["yog"].toString();
      panchang_res_nakshatra = panchang_response["nakshatra"].toString();
      panchang_res_karan = panchang_response["karan"].toString();
      panchang_res_sunrise = panchang_response["sunrise"].toString();
      panchang_res_sunset = panchang_response["sunset"].toString();


    /* if (response_birth_year != null) {
      response_birth_year = (birth_response['year']).toString();
    }
    else {
      response_birth_year = '';
    }

    if (response_birth_month != null) {
      response_birth_month = (birth_response['month']).toString();
    }
    else {
      response_birth_month = '';
    }


    if (response_birth_day != null) {
      response_birth_day = (birth_response['day']).toString();
    }
    else {
      response_birth_day = '';
    }

*/
    // print(response.body);

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

  /*void _runFilter(String enteredKeyword) {
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
  }*/


  @override
  Widget build(BuildContext context) {

    cf.Size.init(context);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Panchang', style: TextStyle(
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
              margin: EdgeInsets.all(20),
              child:


              Column(children: <Widget>[

                Text('Todays Panchang',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 3.5,color: Colors.red,fontFamily: 'Poppins')),

                Container(
                  decoration:BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        width: 1.0,
                        color: const Color(0xffe22525),
                      )
                  ),
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Table(


                      //defaultColumnWidth: FixedColumnWidth(120.0),
                      /* border: TableBorder.all(
                                                 color: Colors.black,
                                                 style: BorderStyle.solid,
                                                 width: 2),*/
                      children: [
                        /* TableRow( children: [
                                      Column(children:[Text('Name',textAlign: TextAlign.left)]),
                                      Column(children:[Text(bir)]),
                                    ]),*/
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Day',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.red,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_res_day}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Tithi',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.red,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_res_tithi}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Yog',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.red,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_res_yog}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Nakshatra',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.red,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_res_nakshatra}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Karan',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.red,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_res_karan}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunrise',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.red,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_res_sunrise}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),
                        TableRow( children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('Sunset',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.red,fontFamily: 'Poppins'))]),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,children:[Text('${panchang_res_sunset}',style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 2.8,color: Colors.black,fontFamily: 'Poppins'))]),
                        ]),



                      ],
                    ),
                  ),
                ),
              ])
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


}
