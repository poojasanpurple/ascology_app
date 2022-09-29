import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/get_chat_listing.dart';

class GetChatListingResponse {
  bool status;
  String message;
  List<ChatDetails> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  GetChatListingResponse();

  factory GetChatListingResponse.fromJson(Map<dynamic, dynamic> json){
    GetChatListingResponse chatListingResponse = new GetChatListingResponse();
    chatListingResponse.status = json["status"];
    chatListingResponse.message = json["message"];

    var list = json["data"] as List;

    chatListingResponse.data = list.map((i) => ChatDetails.fromJson(i)).toList();

    return chatListingResponse;
  }

/*factory AstrologerListingResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      var tagObjsJson = json['data'] as List;
      List<AstrologerDetails> _astrologertags = tagObjsJson
          .map((tagJson) => AstrologerDetails.fromJson(tagJson))
          .toList();

      return AstrologerListingResponse(
          json['status'] as bool, json['message'], _astrologertags);
    }
  }*/
}