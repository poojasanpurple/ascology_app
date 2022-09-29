
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/agent_login_request.dart';
import 'package:ascology_app/model/request/user_payment_request.dart';
import 'package:ascology_app/model/request/user_request.dart';
import 'package:ascology_app/model/response/agent_login_response.dart';
import 'package:ascology_app/model/response/my_wallet_response.dart';
import 'package:ascology_app/model/response/user_chngpasswd_response.dart';
import 'package:ascology_app/model/response/wallet_details_response.dart';
import 'package:ascology_app/screens/agent_forgtpasswd.dart';
import 'package:ascology_app/screens/agent_home.dart';
import 'package:ascology_app/screens/agent_register.dart';
import 'package:ascology_app/screens/user_transaction_history.dart';
import 'package:ascology_app/utility/widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ascology_app/global/configFile.dart' as cf;


class AddMoneyTowallet extends StatefulWidget {
  // const Login({Key key}) : super(key: key);

  @override
  _AddMoneyTowalletState createState() => _AddMoneyTowalletState();
}

class _AddMoneyTowalletState extends State<AddMoneyTowallet> {

  final formKey = GlobalKey<FormState>();
  String wallet_amt, session_user_id,session_useremail,session_user_mobile,session_username;
  SharedPreferences logindata;

  TextEditingController moneycontroller = TextEditingController();
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  Razorpay razorpay;
  bool isLoading = false;

  bool _value = false;
  int val = -1;
  //int newval = 1;
  var paymentId;
  String wallet_balance = '0';

  @override
  void initState() {
    super.initState();

    getConnectivity();
    getsessionuserdata();
    get_wallet_balance();
    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
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


  void getsessionuserdata() async{
    logindata = await SharedPreferences.getInstance();
    setState(() {
      session_user_id = logindata.getString('user_id');
      session_useremail = logindata.getString('user_email');
      session_user_mobile = logindata.getString('user_mobile');
      session_username = logindata.getString('user_name');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
    razorpay.clear();
  }

  void openCheckout(){
    var options = {
      "key" : 'rzp_live_fcRtrqpaA0DFfG',
      "amount" : num.parse(val.toString())*100,
      //"amount" : num.parse(newval.toString())*100,
      "name" : "AstroAshram",
      "description" : "Pay to AstroAshram",
      "prefill" : {
        "contact" : session_user_mobile,
        "email" : session_useremail,
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
      print(e.toString());
    }

  }

  void handlerPaymentSuccess(PaymentSuccessResponse response){
    print("Payment success");
    print(response.paymentId);
    paymentId = response.paymentId;

    sendpaymentsuccess();
   // Toast.show("Payment success", context);
  }

  void handlerErrorFailure(){
    print("Pament error");
   // Toast.show("Payment error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
  //  Toast.show("External Wallet", context);
  }

  void sendpaymentsuccess() async{

    logindata = await SharedPreferences.getInstance();

    //  loaderFun(context, true);
          var _loginApiClient = LoginApiClient();
          UserPaymentRequestModel requestModel = new UserPaymentRequestModel();
          requestModel.amount = val.toString();
          requestModel.user_id = session_user_id;
          //  loginRequestModel.token = '';
          requestModel.invoice_num = '';
          requestModel.payment_mode = 'online';
          requestModel.payment_status = 'success';
          requestModel.payment_id = paymentId.toString();
          requestModel.payment_date = '';
          requestModel.mobile = session_user_mobile;
          requestModel.email = session_useremail;
          requestModel.user_name = session_username;

          UserChangePasswordResponseModel userModel = await _loginApiClient.sendpaymentdetails(requestModel);
          print("!Q!Q!QQ!Q!Q!Q $userModel");
          if(userModel.status = true){
            print('Agent Login successful');

            Fluttertoast.showToast(
                msg: "Payment successful...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0
            );

            // logindata.setBool('login', false);

          }
          else
          {
            //  loaderFun(context, false);
            print('Failed');
          }


  }


  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Wallet', style: TextStyle(
              color: Colors.white,
              fontSize: cf.Size.blockSizeHorizontal*4
          ),) ,

          flexibleSpace: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/getnow.png'),
                    fit: BoxFit.fill
                )
            ),
          ),


          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserTransactionHistory()));

              },
              icon: Icon(Icons.history),
            ),



          ],),
        body:


        SingleChildScrollView(
          child:
    Column(
      children: [

        SizedBox(height: 20),
      Text('Wallet Balance : ₹  ${wallet_balance}',style: TextStyle(
        //Text('Wallet Balance : ₹ '+ wallet_balance,style: TextStyle(
        fontSize: cf.Size.blockSizeHorizontal*3.5,
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),),
        Card(
          margin: EdgeInsets.all(30.0),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40), // if you need this
        side: BorderSide(
        color: Colors.grey.withOpacity(0.2),
        width: 1,
        ),
        ),
        child:Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(40.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose amount to add to wallet',style: TextStyle(
                        fontSize: cf.Size.blockSizeHorizontal*3.2,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),),





                      ListTile(
                        title: Text("₹ 100",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 100,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                      ListTile(
                        title: Text("₹ 200",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 200,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),

                      ListTile(
                        title: Text("₹ 300",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 300,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),


                      ListTile(
                        title: Text("₹ 500",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 500,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),


                      ListTile(
                        title: Text("₹ 1100",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 1100,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),

                      ListTile(
                        title: Text("₹ 2100",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 2100,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),

                      ListTile(
                        title: Text("₹ 3100",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 3100,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),


                      ListTile(
                        title: Text("₹ 5100",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 5100,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),

                      ListTile(
                        title: Text("₹ 11000",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 11000,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),

                      ListTile(
                        title: Text("₹ 21000",style:TextStyle( fontSize: cf.Size.blockSizeHorizontal * 3.5,fontFamily: 'Poppins')),
                        leading: Radio(
                          value: 21000,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                     /* SizedBox(height: 5.0,),
                      TextFormField(
                        autofocus: false,
                        //validator: validateEmail,
                        onSaved: (value)=> wallet_amt = value,
                        keyboardType: TextInputType.number,
                        controller: moneycontroller,
                        decoration: buildInputDecoration('Enter amount',Icons.money),
                      ),*/
                      SizedBox(height: 20.0,),


                      Container(
                        alignment: Alignment.center,
                        child : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: const Color(0xffe22525)),
                          child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w300,fontSize: cf.Size.blockSizeHorizontal * 3.3),),
                          onPressed: ()
                          {

                            openCheckout();
                            // Navigator.pushReplacementNamed(context, '/login');
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()),);


                          },
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              ),
      ],
    ),
        ),
      ),
    );
  }

  void get_wallet_balance() async {

    setState(() {
      isLoading = true;
    });


    logindata = await SharedPreferences.getInstance();
    session_user_id = logindata.getString('user_id');

      //  loaderFun(context, true);
      var _loginApiClient = LoginApiClient();
      // LoginRequestModel loginRequestModel =  LoginRequestModel(_userName,_password,'','','',apkversion,'');
      UserRequestModel requestModel = UserRequestModel();
      //_userName,_password,'1234','','',apkversion,'');
      requestModel.user_id = session_user_id;

      print(session_user_id);
    WalletResponseModel details =
      await _loginApiClient.getwalletbalance(requestModel);

      print("!Q!Q!QQ!Q!Q!Q ${requestModel.toString()}");
      // (data?.isEmpty ?? true
      //  if (userModel?.status ?? true) {
      //   if (userModel!=null) {
      //  if (userModel.status == true) {
      if (details.status == true) {
        setState(() {
          isLoading = false;
        });


        print('User Login successful');

       /* if(details.data == null) {

          wallet_balance = '0';
         *//* if (details.data[0].amount == null) {
            wallet_balance = '0';
          }*//*
        }
        else
          {*/
            wallet_balance = details.data[0].amount.toString();
       /* Fluttertoast.showToast(
            msg: wallet_balance.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );*/


        //  }

      }
      else {

        wallet_balance = '0';
        /*Fluttertoast.showToast(
            msg: "Invalid login details...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print('User Login failed');*/
      }

    }





  }

