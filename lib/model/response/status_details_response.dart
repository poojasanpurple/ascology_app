import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class StatusDetails
{

  String id;
  String agent_id;
  String date;
  String from_time;
  String to_time;
  String type;
  String status;


  StatusDetails();

  factory StatusDetails.fromJson(Map<String, dynamic> json) {
    StatusDetails userDetails = new StatusDetails();
    userDetails.id =  json["id"];
    userDetails.agent_id =  json["agent_id"];
    userDetails.date =  json["date"];
    userDetails.from_time =  json["from_time"];
    userDetails.to_time =  json["to_time"];
    userDetails.type =  json["type"];
    userDetails.status =  json["status"];

    return userDetails;

  }
}