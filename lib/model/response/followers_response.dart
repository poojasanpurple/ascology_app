import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class FollowersDetails
{
  String id;
  String agent_id;

  String user_id;
  String name;



  FollowersDetails();

  factory FollowersDetails.fromJson(Map<String, dynamic> json) {
    FollowersDetails details = new FollowersDetails();
    details.id =  json["id"];
    details.agent_id =  json["agent_id"];
    details.user_id =  json["user_id"];
    details.name =  json["name"];

    return details;

  }
}