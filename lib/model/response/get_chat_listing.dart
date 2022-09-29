import 'package:ascology_app/model/response/astrologer_listing_response.dart';

class ChatDetails
{
  String id;
  String agent_id;

  String user_id;
  String chat_from;
  String chat_to;
  String txt_message;
  String entry_date;
  String read_unread;


  ChatDetails();

  factory ChatDetails.fromJson(Map<String, dynamic> json) {
    ChatDetails details = new ChatDetails();
    details.id =  json["id"];
    details.agent_id =  json["agent_id"];
    details.user_id =  json["user_id"];
    details.chat_from =  json["chat_from"];
    details.chat_to =  json["chat_to"];
    details.txt_message =  json["txt_message"];
    details.entry_date =  json["entry_date"];
    details.read_unread =  json["read_unread"];

    return details;

  }
}