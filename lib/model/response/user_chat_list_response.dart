import 'package:ascology_app/model/response/testimonal_details_response.dart';
import 'package:ascology_app/model/response/user_chatlist_detail.dart';

class UserChatListResponse
{
  bool status;
  String message;
  List<UserChatDetail> data;

//  AstrologerListingResponse(this.status, this.message, [this.data]);

  UserChatListResponse();

  factory UserChatListResponse.fromJson(Map<dynamic, dynamic> json){
    UserChatListResponse response = new UserChatListResponse();
    response.status = json["status"];
    response.message = json["message"];

    var list = json["data"] as List;

    response.data = list.map((i) => UserChatDetail.fromJson(i)).toList();

    return response;
  }


}