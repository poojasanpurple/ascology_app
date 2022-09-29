import 'package:ascology_app/model/response/astrologer_list_detail.dart';
import 'package:ascology_app/model/response/user_chat_hist_response.dart';
import 'package:ascology_app/model/response/user_detail_response.dart';

class UserChatMainResponse {
  bool status;
  String message;
  List<UserChatHistResponse> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  UserChatMainResponse();

  factory UserChatMainResponse.fromJson(Map<dynamic, dynamic> json){
    UserChatMainResponse listingResponse = new UserChatMainResponse();
    listingResponse.status = json["status"];
    listingResponse.message = json["message"];

    var list = json["data"] as List;

    listingResponse.data = list.map((i) => UserChatHistResponse.fromJson(i)).toList();

    return listingResponse;
  }

}