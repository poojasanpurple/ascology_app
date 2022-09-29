
import 'dart:async';

import 'package:ascology_app/model/LoginApiClient.dart';
import 'package:ascology_app/model/request/static_data_request.dart';
import 'package:ascology_app/model/response/gallery_details_response.dart';
import 'package:ascology_app/model/response/gallery_response.dart';
import 'package:ascology_app/model/response/static_data_response.dart';
import 'package:ascology_app/model/response/videodetails_response.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ascology_app/global/configFile.dart' as cf;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class GalleryPage extends StatefulWidget {
  // const Register({Key? key}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  List<GalleryDetails> gallerylist = List();
  List<VideoDetailsResponse> videolist = List();
  List<String> urllist = [];
  List<String> video_id_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    fetch_gallery();
    fetch_videos();
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

  void fetch_gallery() async {

    LoginApiClient api = LoginApiClient();

    gallerylist = await api.getgallery();

    setState(() {
      gallerylist = gallerylist;
    });

  }

  void fetch_videos() async {

    LoginApiClient api = LoginApiClient();

    videolist = await api.getvideos();

    setState(() {
      videolist = videolist;
    });

    for(int i = 0; i< videolist.length; i++)
      {
        urllist.add(videolist[i].video);

      }

    for(int a = 0; a< urllist.length; a++)
      {
        video_id_list.add(YoutubePlayer.convertUrlToId(urllist[a]));
      }

  }



  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return SafeArea(
      child:
      Scaffold(
          resizeToAvoidBottomInset:false,
          appBar: AppBar(
            title: Text('Gallery', style: TextStyle(
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

          SingleChildScrollView
            (
            child:Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: gallerylist.isEmpty?
            Container(
              width: cf.Size.screenWidth,
              height: cf.Size.screenHeight,
              alignment: AlignmentDirectional.center,
              child: Container(
                  child: Center(
                      child: Image.asset(
                        "assets/images/loader.gif",
                        height: cf.Size.screenHeight,
                        width: cf.Size.screenWidth,
                      )
                  )
              ),
            )
                :

            /*  ListView.builder(
            itemCount: dataFromServer.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return UserChat(
                agentname : dataFromServer[index].agentname,
              //  imageUrl: dataFromServer[index].imageURL,
              //  time: chatUsers[index].time,
                //isMessageRead: (index == 0 || index == 3)?true:false,
              );
            },
          ),*/

            Column(
              children: [
                Column(
                  children: [

                    GridView.builder(

                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8

                      ),

                      itemCount: gallerylist.length,
                      itemBuilder: (context,index){


                        if(gallerylist!=null && gallerylist.length!=0)
                        {

                          var profileUrl = gallerylist[index].image;
                          print('url'+profileUrl.toString());

                          return

                            GestureDetector(
                              onTap: () {

                              },
                              child:
                              Container(
                                decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                ),
                        child:ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                        decoration: BoxDecoration(
                        image: DecorationImage(
                        image: NetworkImage('https://astroashram.com/uploads/agent_upload_image/'+profileUrl),
                        fit: BoxFit.cover,
                        ),
                        ),
                             /*   child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ListTile(
                                    title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        //mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[

                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            width: 100,
                                            height:100,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                               //borderRadius: BorderRadius.circular(60/2),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: profileUrl !=" "?NetworkImage('https://astroashram.com/uploads/agent_upload_image/'+profileUrl) : NetworkImage('assets/images/profile.png')
                                                  //daee640aaf2738bec6203e1c22e22412.jpg')
                                                )
                                            ),
                                          ),



                                      ],


                              ),
                            ),
                            ),*/
                                      ),
                            ),),);

                            /*Card(
                              elevation: 1.5,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child:

                                ListTile(
                                    title: Column(
                                      children: <Widget>[


                                        Center(
                                          child: ClipRRect(
                                            child: Image.network('https://astroashram.com/uploads/agent_upload_image/'+profileUrl
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                    onTap: ()
                                    {

                                    }
                                ),
                              ),
                            );*/
                        }
                      },

                    ),


                    GridView.builder(

                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 4,
                        mainAxisSpacing: 5,
                        mainAxisExtent: 200,
                      ),

                      itemCount: video_id_list.length,
                      itemBuilder: (context,index){


                        if(video_id_list!=null && video_id_list.length!=0)
                        {

                          return

                            GestureDetector(
                              onTap: () {

                              },
                              child:
                              Container(
                                decoration:BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    )
                                ),
                                child:
                                YoutubePlayer(
                                  controller: YoutubePlayerController(
                                    initialVideoId: video_id_list[index], //Add videoID.
                                    flags: YoutubePlayerFlags(
                                      hideControls: false,
                                      controlsVisibleAtStart: true,
                                      autoPlay: false,
                                      mute: false,
                                    ),
                                  ),
                                  showVideoProgressIndicator: true,
                                  progressIndicatorColor: Colors.red,
                                ),
                              ),
                            );

                          /*Card(
                      elevation: 1.5,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child:

                        ListTile(
                            title: Column(
                              children: <Widget>[


                                Center(
                                  child: ClipRRect(
                                    child: Image.network('https://astroashram.com/uploads/agent_upload_image/'+profileUrl
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            onTap: ()
                            {

                            }
                        ),
                      ),
                    );*/
                        }
                      },

                    ),
                  ],
                ),
              ],
            ),



          ),),


      ),
    );

  }


}
