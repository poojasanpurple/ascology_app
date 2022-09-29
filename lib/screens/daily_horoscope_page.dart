
import 'dart:async';
import 'dart:convert';

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
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class DailyHoroscopePage extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _DailyHoroscopePageState createState() => _DailyHoroscopePageState();
}

class _DailyHoroscopePageState extends State<DailyHoroscopePage> {

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

  List<String> strArr_zodiac = ['Capricorn', 'Aquarius','Pisces','Aries','Taurus',
  'Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius'];

  String res_sunsign,res_pred_date, res_pred;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();

    for(int i= 0 ; i<=11; i++) {
      getdailyhoroscope(strArr_zodiac[i]);
    }

     Fluttertoast.showToast(
          msg: 'Your subscribed plan is not authorized to access this API. Kindly visit your dashboard',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    /*   fromdatecontroller.text = formatter;
    todatecontroller.text = formatter;
    this.getuser_callhistory_current();*/
  }

  void getdailyhoroscope(String zodiac_name) async {

    DateTime now = DateTime.now();
    //  var timezone = now.timeZoneName;
    var toffset = now.timeZoneOffset;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://json.astrologyapi.com/v1/horoscope_prediction/daily/'+zodiac_name);
    final headers = {"authorization": "Basic " + base64.encode(utf8.encode("619558:fad80d4883db59a54e377aa96f515e72")),"Content-type": "application/json"};

    // place_lat = place_lat.replaceAll('{', '');

    // LoginApiClient api = LoginApiClient();
    //  BirthDetailsRequestModel requestModel = new BirthDetailsRequestModel();

    final json = jsonEncode({
      "timezone":toffset.toString()});

    final response = await post(url, headers: headers, body: json);
    // main_list = await api.getbirthdetails(requestModel);
    setState(() {
      // main_list = main_list;
      // searchlist = callhistorylist;
      isLoading = false;
    });

    var daily_horoscope_response = jsonDecode(response.body.toString());
    print(daily_horoscope_response);

    if(daily_horoscope_response["status"]== true) {
      res_sunsign = daily_horoscope_response["sun_sign"].toString();
      res_pred_date = daily_horoscope_response["prediction_date"].toString();
      res_pred = daily_horoscope_response["prediction"].toString();
    }
    else{

      print('Your subscribed plan is not authorized to access this API. Kindly visit your dashboard');

    }

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
            title: Text('Daily Horoscope', style: TextStyle(
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
            Text(
              '',
              style: TextStyle(fontSize: cf.Size.blockSizeHorizontal * 4),
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


}