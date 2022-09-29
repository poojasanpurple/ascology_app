
import 'dart:async';
import 'dart:convert';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/utility/app_url.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';


class BlogsPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  String blog_id;

  @override
  _BlogsPageState createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  List blogslist = [];
  bool isLoading = false;

  String send_blog_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    this.fetchblogs();
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

  fetchblogs() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.post(AppUrl.get_blog_data);
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'];
      setState(() {
        blogslist = items;
        isLoading = false;
      });
    }else{
      blogslist = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs', style: TextStyle(
            color: Colors.white,
            fontSize: 22
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
      body: getBody(),
    );
  }

  Widget getBody(){
    if(blogslist.contains(null) || blogslist.length < 0 || isLoading){
      return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.black ),));
    }

    return GridView.builder(
      // scrollDirection: ,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: blogslist.length,
        itemBuilder: (context,index){
          return getCard(blogslist[index]);
        });


    /* return ListView.builder(
        itemCount: astrologerslist.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return getCard(astrologerslist[index]);
        });*/
  }


  Widget getCard(item){
    String blog_id = item['id'];
    var blogdesc = item['description'];
    var blogtitle = item['title'];
    var imgurl = item['image'];
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
            title: Column(

              children: <Widget>[

                SizedBox(width: 20),
                Expanded(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(60/2),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://astroashram.com/uploads/blog/'+imgurl)
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text(blogtitle,style: TextStyle(fontSize: 17,fontFamily: 'Poppins'),textAlign: TextAlign.center)),
                    SizedBox(height: 5),
                    SizedBox(width: MediaQuery.of(context).size.width/2,
                        child: Html(data:blogdesc.toString()),
                    ),

                  ],
                ),)
              ],
            ),
            onTap: ()
            {

             /* Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AstroDescription(agent_id: agent_id) ;
                    },
                  ));
*/
            }
        ),
      ),
    );
  }
}