
import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_request_model.dart';
import 'package:ascology_app/model/request/agent_update_profile.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/request/user_update_profile.dart';
import 'package:ascology_app/model/response/astrologer_listing_response.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/model/response/user_response.dart';
import 'package:ascology_app/model/response/userforget_passwd_response.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:ascology_app/utility/multiselect_agent.dart';
import 'package:ascology_app/utility/multiselectwidget.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ascology_app/global/configFile.dart' as cf;

class EditAgentProfile extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);
  @override
  _EditAgentProfileState createState() => _EditAgentProfileState();
}

class _EditAgentProfileState extends State<EditAgentProfile> {

  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = false;
  var items =  ['Select','Astrology','Numerology','Psychology','Tarot Reading'];
  var languages =  ['Select','Assamese','Bengali','English','Gujarati','Hindi','Kannada','Maithili','Malayalam','Marathi','Odia','Punjabi','Sanskrit','Tamil','Telugu','Urdu'];
  List<String> problemarealist = [];
  MultiSelectController myMultiSelectController = MultiSelectController();
  int sel;
  List expertiselist = [];

  String desc_all, new_desc_all = "";

  String session_user_id;
  String deviceName = '';
  String deviceVersion = '';
  String identifier = '';
  String apkversion = '1.0';
  String reg_email, reg_name, reg_mobile,reg_gender, reg_short_desc , reg_birthdate, reg_birthplace,
      reg_time,reg_img,birth_location,dropdownvalue_gender,formattedTime,session_agent_id;
  String agent_name,agent_mobile,agent_price,agent_timing,agent_img,agent_language,agent_category;
  String agent_exp,agent_about,dropdownvalue_category,dropdownvalue_language;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController mobilecontroller = TextEditingController();
  TextEditingController gendercontroller = TextEditingController();
  TextEditingController short_desc_controller = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController birthplacecontroller = TextEditingController();
  TextEditingController birthtimeplacecontroller = TextEditingController();
  TextEditingController birthdatecontroller = TextEditingController();
  TextEditingController agenttimingsController = TextEditingController();
  SharedPreferences logindata;
  String user_name,user_mobile,user_email,user_gender,user_desc,user_img,
      user_birthdate,user_birthplace,user_time,cat_id,lang_id,agent_timings;
  DateTime selectedDate = DateTime.now();
  List<String> selectedlist = [];

  // var uuid= new Uuid();
  // var uuid= new Uuid();
  // String _sessionToken = new Uuid();
  List<dynamic>_placeList = [];

  final formKey = GlobalKey<FormState>();

  String _selectedGender ;
  var _selectedTime,finaltime;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    this.getexpertise(context);

    myMultiSelectController.disableEditingWhenNoneSelected = true;
    myMultiSelectController.set(problemarealist.length);
    fetch_Agent_details();


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

  void getexpertise(BuildContext context) async {
    setState(() {
      //isLoading = true;
    });
    var response = await http.post(AppUrl.get_expertise);
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      setState(() {
        expertiselist = items;
        //  isLoading = false;
        for(int i = 0; i < expertiselist.length;i++)
        {
          problemarealist.add(expertiselist[i]['name']);
        }
      });
    }else{
      expertiselist = [];
      // isLoading = false;
    }

  }

  void _showMultiSelect() async {

    final List<String> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectAgent(items: problemarealist);
      },
    );



    // Update UI
    if (results != null) {
      setState(() {
        selectedlist = results;

        // selectedlist = results + gotlist;

        for(int i = 0; i< selectedlist.length;i++)
        {

          // if(selectedlist[i] == problemarealist[])
          // desc_all = desc_all + ',' + selectedlist[i];
          new_desc_all = new_desc_all + ',' +  selectedlist[i];
        }

        //   short_desc_controller.text = '${desc_all}';
        print(selectedlist);
        print(new_desc_all);
      });
    }
  }

  void fetch_Agent_details() async {
    setState(() {
      isLoading = true;
    });
    logindata = await SharedPreferences.getInstance();
    session_agent_id = logindata.getString('agent_id');

    var _loginApiClient = LoginApiClient();
    AgentRequestModel model = AgentRequestModel();
    model.agent_id = session_agent_id;
    print(model.toString());

    AstrologerListingResponse listingResponse = await _loginApiClient.getagentprofile(model);

    print("!Q!Q!QQ!Q!Q!Q ${listingResponse.toString()}");
    // (data?.isEmpty ?? true
    //  if (userModel?.status ?? true) {
    //   if (userModel!=null) {
    //  if (userModel.status == true) {
    if (listingResponse.status = true) {
      print(listingResponse.data);
      setState(() {
        isLoading = false;
      });

      agent_name = listingResponse.data[0].agentname.toString();
      agent_mobile = listingResponse.data[0].mob.toString();
      agent_price = listingResponse.data[0].price.toString();
      agent_timing = listingResponse.data[0].timing.toString();
      desc_all = listingResponse.data[0].short_description.toString();
      agent_img = listingResponse.data[0].image.toString();
      agent_exp = listingResponse.data[0].experience.toString();
      agent_about = listingResponse.data[0].about.toString();
      agent_language = listingResponse.data[0].id_language.toString();
      agent_category = listingResponse.data[0].id_service.toString();
print('agent_category'+agent_category);
      //  String a = AstrologerDetails.fromJson(userModel.data).agentname;

setState(() {


      if(agent_category == '1') {
        dropdownvalue_category = 'Psychology';
      }
      else if(agent_category == '2')
      {
        dropdownvalue_category = 'Numerology';

      }
      else if(agent_category == '3')
      {
        dropdownvalue_category == 'Tarot Card';
      }
      else if(agent_category == '4')
      {
        dropdownvalue_category == 'Astrology';
      }
      else
        {
          dropdownvalue_category == 'Select';
        }

});

      print(dropdownvalue_category);

      setState(() {
        if (agent_language == '1') {
          dropdownvalue_language = 'English';
        }
        else if (agent_language == '2') {
          dropdownvalue_language = 'Hindi';
        }
        else if (agent_language == '3') {
          dropdownvalue_language = 'Gujarati';
        }
        else if (agent_language == '4') {
          dropdownvalue_language = 'Bengali';
        }
        else if (agent_language == '5') {
          dropdownvalue_language = 'Marathi';
        } else if (agent_language == '6') {
          dropdownvalue_language = 'Telugu';
        } else if (agent_language == '7') {
          dropdownvalue_language = 'Tamil';
        } else if (agent_language == '8') {
          dropdownvalue_language = 'Urdu';
        } else if (agent_language == '9') {
          dropdownvalue_language = 'Kannada';
        } else if (agent_language == '10') {
          dropdownvalue_language = 'Odia';
        } else if (agent_language == '11') {
          dropdownvalue_language = 'Malayalam';
        } else if (agent_language == '12') {
          dropdownvalue_language = 'Punjabi';
        } else if (agent_language == '13') {
          dropdownvalue_language = 'Assamese';
        } else if (agent_language == '14') {
          dropdownvalue_language = 'Maithili';
        } else if (agent_language == '15') {
          dropdownvalue_language = 'Sanskrit';
        }
        else
        {
          dropdownvalue_language == 'Select';
        }
      });

    fullnameController.text = '${agent_name}';
      short_desc_controller.text = '${desc_all}';
      mobilecontroller.text = '${agent_mobile}';

      if(agent_exp == "") {
        expController.text = '0';
      }
      else
        {
          expController.text = '${agent_exp}';
        }
      /*  AstrologerDetails details = AstrologerDetails();
          details.agentname = userModel.data.asMap()
*/
    }
    else {
      print(listingResponse.message);
      isLoading = false;
    }

  }



  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    //  _deviceDetails();


    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Profile', style: TextStyle(
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(40.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0,),
                    Text('Name*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      // validator: validateEmail,
                      controller: fullnameController,
                      onSaved: (value) => reg_name = value,
                      decoration: buildInputDecoration("Enter Name", Icons.person),

                    ),
                   SizedBox(height: 20.0,),
                    Text('Mobile number*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 5.0,),
                    TextFormField(
                      style: TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      autofocus: false,
                      keyboardType: TextInputType.number,

                      maxLength: 10,
                      //  validator: validateEmail,
                      onSaved: (value) => reg_mobile = value,
                      controller: mobilecontroller,
                      decoration: buildInputDecoration("Enter mobile number", Icons
                          .call),
                    ),
                    SizedBox(height: 20.0,),

                    Text('Experience (in years)*',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),
                    SizedBox(height: 15.0,),
                    NumberInputWithIncrementDecrement(
                      style:TextStyle(
                          fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),
                      controller: expController,
                      min: 0,
                      onIncrement: (num newlyIncrementedValue) {
                        print('Newly incremented value is $newlyIncrementedValue');
                      },
                      onDecrement: (num newlyDecrementedValue) {
                        print('Newly decremented value is $newlyDecrementedValue');
                      },

                    ),
                    SizedBox(height: 20.0,),

                    Container(
                      // child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          Text("Select Category *",style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),),
                          SizedBox(width : 15.0,),

                          DropdownButton(
                            value: dropdownvalue_category,

                            icon: Icon(Icons.keyboard_arrow_down),

                            items:items.map((String items) {
                              return DropdownMenuItem(
                                  value: items,
                                  child: Text(items,style: TextStyle(
                                  fontSize: cf.Size.blockSizeHorizontal * 2.5,
                                      fontFamily: "Poppins"),)
                              );
                            }
                            ).toList(),
                            onChanged: (newValue){
                              setState(() {

                                dropdownvalue_category = newValue.toString();
                              });
                            },

                          ),
                        ],
                      ),
                      // ),
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      // child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Select language *",style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 3,
                          fontFamily: "Poppins"),),

                          SizedBox(width : 15.0,),
                          DropdownButton(
                            value: dropdownvalue_language,
                            icon: Icon(Icons.keyboard_arrow_down),

                            items:languages.map((String items) {
                              return DropdownMenuItem(
                                  value: items,
                                  child: Text(items,style: TextStyle(
                                      fontSize: cf.Size.blockSizeHorizontal * 2.8,
                                      fontFamily: "Poppins"),)
                              );
                            }
                            ).toList(),
                            onChanged: (newValue){
                              setState(() {
                                dropdownvalue_language = newValue.toString();
                              });
                            },

                          ),
                        ],
                      ),
                      //  ),
                    ),



                    SizedBox(height: 20.0,),

                    Text("Edit your expertise *",style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                        fontFamily: "Poppins"),),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: const Color(0xffe22525)),
                      child:  Text('Select your expertise areas',style: TextStyle(
                      fontSize: cf.Size.blockSizeHorizontal * 2.5,
                          fontFamily: "Poppins"),),
                      onPressed: _showMultiSelect,

                    ),


                    Wrap(
                      children: selectedlist
                          .map((e) => Chip(
                        label: Text(e,style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal * 3,
                            fontFamily: "Poppins"),),
                      ))
                          .toList(),


                    ),

                Visibility(child:

                    TextFormField(
                      autofocus: false,
                      maxLines: 5,
                      readOnly: true,
                      //  onSaved: (value) => reg_short_desc = value,
                      onSaved: (value) => desc_all = value,
                      decoration: buildInputDecoration(
                          "Enter short desc", Icons.description),
                      controller: short_desc_controller,
                    ),
                    visible : false),


                    GestureDetector(
                      onTap: () {
                        update_agent_profile(context);
                        //print('do something');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.fromLTRB(
                            50.0, 30, 50.0, 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all( width: 1,color: const Color(0xffe22525)),
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/getnow.png'),
                              fit: BoxFit.cover
                          ),
                        ), // button text
                        child: Text("Update", style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: cf.Size.blockSizeHorizontal * 3.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white

                        ),),
                      ),
                    ),


                    SizedBox(height: 20.0,),

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }





  void update_agent_profile(BuildContext context) async{

    reg_name = fullnameController.text;
    reg_mobile = mobilecontroller.text;
    reg_short_desc = short_desc_controller.text;

    // UserForgetPasswordResponseModel

    // print("phoneNumber.length ${phoneNumber.length}");
    var _loginApiClient = LoginApiClient();
    AgentUpdateProfileRequest registerRequestModel = new AgentUpdateProfileRequest();

    registerRequestModel.agent_id = session_agent_id;
    registerRequestModel.name = reg_name;

    if(dropdownvalue_category == 'Psychology') {
      cat_id = '1';
    }
    else if(dropdownvalue_category == 'Numerology')
    {
      cat_id = '2';
    }
    else if(dropdownvalue_category == 'Tarot Card')
    {
      cat_id = '3';
    }
    else if(dropdownvalue_category == 'Astrology')
    {
      cat_id = '4';
    }

    registerRequestModel.service = cat_id;
    print(dropdownvalue_category);

    if(dropdownvalue_language == 'English') {
      lang_id = '1';
    }
    else if(dropdownvalue_language == 'Hindi')
    {
      lang_id = '2';
    }
    else if(dropdownvalue_language == 'Gujarati')
    {
      lang_id = '3';
    }
    else if(dropdownvalue_language == 'Bengali')
    {
      lang_id = '4';
    }
    else if(dropdownvalue_language == 'Marathi')
    {
      lang_id = '5';
    } else if(dropdownvalue_language == 'Telugu')
    {
      lang_id = '6';
    } else if(dropdownvalue_language == 'Tamil')
    {
      lang_id = '7';
    } else if(dropdownvalue_language == 'Urdu')
    {
      lang_id = '8';
    } else if(dropdownvalue_language == 'Kannada')
    {
      lang_id = '9';
    } else if(dropdownvalue_language == 'Odia')
    {
      lang_id = '10';
    } else if(dropdownvalue_language == 'Malayalam')
    {
      lang_id  = '11';
    } else if(dropdownvalue_language == 'Punjabi')
    {
      lang_id = '12';
    } else if(dropdownvalue_language == 'Assamese')
    {
      lang_id = '13';
    } else if(dropdownvalue_language == 'Maithili')
    {
      lang_id = '14';
    } else if(dropdownvalue_language == 'Sanskrit')
    {
      lang_id = '15';
    }

    registerRequestModel.language = lang_id;

    registerRequestModel.timing = agent_timing;
    registerRequestModel.experience = expController.text;

    registerRequestModel.description = new_desc_all;

    print(registerRequestModel);

    UserChangePasswordResponseModel registerResModel = await _loginApiClient.updateagent(registerRequestModel);

    if(registerResModel.status == true){

      Fluttertoast.showToast(
          msg: "Profile updated successfully...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );



    }
    else{
      //loaderFun(context, false);
      //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text('Unable to create account.')));

      Fluttertoast.showToast(
          msg: "Unable to update details...",
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
